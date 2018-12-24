# Ubuntu-only stuff. 
is_ubuntu || return 1

deb_installed=()
deb_sources=()

INSTALLERS_PATH="$DOTFILES/caches/installers"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ADD DEB PACKAGES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

deb_installed+=(/usr/bin/discord)
deb_sources+=("https://discordapp.com/api/download?platform=linux&format=deb")

deb_installed+=(/usr/bin/hyper)
deb_sources+=("https://github.com/zeit/hyper/releases/download/2.1.0/hyper_2.1.0_amd64.deb")

deb_installed+=(/usr/bin/slack)
deb_sources+=("https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.3-amd64.deb")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# UTILITY FUNCTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function install_debs() {

  local i

  mkdir -p "$INSTALLERS_PATH"

  for i in "${deb_installed_i[@]}"; do

    deb="${deb_sources[i]}"
    
    if [[ "$(type -t "$deb")" == function ]]; then
    
      deb="$($deb)"

    fi

    installer_file="$INSTALLERS_PATH/$(echo "$deb" | sed 's#.*/##')"
    
    execute \
      "wget -qO '$installer_file' '$deb' && sudo dpkg -i '$installer_file'" \
      "${deb_installed[i]}"

  done

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# INSTALL DEBS VIA DPKG
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function __temp() { [[ ! -e "$1" ]]; }
deb_installed_i=($(array_filter_i deb_installed __temp))

print_header "Installing debs (${#deb_installed_i[@]})"

if (( ${#deb_installed_i[@]} > 0 )); then

  install_debs

fi
