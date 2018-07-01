# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# ---------------------------
# VARS AND CONSTS
# ---------------------------

apt_keys=()
apt_packages=()
apt_source_files=()
apt_source_texts=()
deb_installed=()
deb_sources=()

INSTALLERS_PATH="$DOTFILES/caches/installers"

# Ubuntu distro release name, eg. "xenial"
RELEASE_NAME=$(lsb_release -c | awk '{ print $2 }' | sed 's/[.]//')


# ---------------------------
# HELPER FUNCTIONS
# ---------------------------


function add_ppa() {
  
  apt_source_texts+=($1)
  
  IFS=':/' eval 'local parts=($1)'
  apt_source_files+=("${parts[1]}-ubuntu-${parts[2]}-$RELEASE_NAME")

}


function add_source_to_etc() {

  local text=$1 file=$2

  sudo sh -c "echo '$text' > /etc/apt/sources.list.d/$file.list"

}


function install_apt_keys() {

  local key

  for key in "${apt_keys[@]}"; do

    if [[ "$key" =~ -- ]]; then

      execute \
        "sudo apt-key adv $key" \
        "$key"

    else

      execute \
        "wget -qO- $key | sudo apt-key add -" \
        "$key"
      
    fi && \
    echo "$key" >> $keys_cache

  done

}


function install_apt_packages() {

  local package

  for package in "${apt_packages[@]}"; do

    if [[ "$(type -t preinstall_$package)" == function ]]; then
    
      execute \
        "preinstall_$package" \
        "$package (pre-install)"

    fi

    execute \
      "sudo apt-get -qq install '$package'" \
      "$package (install)"

    if [[ "$(type -t postinstall_$package)" == function ]]; then

      execute \
        "postinstall_$package" \
        "$package (post-install)"

    fi

  done

}


function install_apt_sources() {

  local i
  
  for i in "${source_i[@]}"; do
  
    source_file=${apt_source_files[i]}
    source_text=${apt_source_texts[i]}
  
    if [[ "$source_text" =~ ppa: ]]; then
  
      execute \
        "sudo add-apt-repository -y $source_text" \
        "$source_text"
  
    else
  
      execute \
        "add_source_to_etc $source_text $source_file" \
        "$source_file"
  
    fi
  
  done

}


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


function install_from_zip() {
  
  local name=$1 url=$2 bins b zip tmp
  
  shift 2; bins=("$@"); [[ "${#bins[@]}" == 0 ]] && bins=($name)
  
  if [[ ! "$(which $name)" ]]; then
  
    mkdir -p "$INSTALLERS_PATH"
    zip="$INSTALLERS_PATH/$(echo "$url" | sed 's#.*/##')"
    wget -qO "$zip" "$url"
    tmp=$(mktemp -d)
    unzip "$zip" -d "$tmp"
  
    for b in "${bins[@]}"; do
  
      sudo cp "$tmp/$b" "/usr/local/bin/$(basename $b)"
  
    done
  
    rm -rf $tmp
    
  fi
  
}


function other_stuff() {

  print_header "Installing bins from zip"
  
  execute \
    "install_from_zip ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip'" \
    "ngrok"

  execute \
    "install_from_zip exa-linux-x86_64 'https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip'" \
    "exa-linux-x86_64"

}


# ---------------------------
# ADD PACKAGES
# ---------------------------


apt_packages+=(
  awscli
  build-essential
  curl
  docker.io
  docker-compose
  git-core
  gnome-tweak-tool
  htop
  postgresql
  python-pip
  thefuck
  vim
)

if is_ubuntu_desktop; then

  apt_packages+=(
    gdebi-core
    libc++1
    network-manager-openvpn
    paper-cursor-theme
    paper-icon-theme
    python3
    python3-pip
    vim-gnome
    vlc
  )

  # # https://github.com/tagplus5/vscode-ppa
  # apt_keys+=(https://tagplus5.github.io/vscode-ppa/ubuntu/gpg.key)
  # apt_source_files+=(vscode)
  # apt_source_texts+=("deb https://tagplus5.github.io/vscode-ppa/ubuntu ./")
  # apt_packages+=(code code-insiders)

  # # https://www.spotify.com/us/download/linux/
  # apt_keys+=('--keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90')
  # apt_source_files+=(spotify)
  # apt_source_texts+=("deb http://repository.spotify.com stable non-free")
  # apt_packages+=(spotify-client)

fi


# ---------------------------
# ADD PACKAGE ARCHIVES
# ---------------------------

print_header "Adding PPAs"

execute \
  "add_ppa ppa:linuxuprising/java" \
  "ppa:linuxuprising/java"

apt_packages+=(
  oracle-java10-installer
  oracle-java10-set-default
)

function preinstall_oracle-java10-installer() {
  
  echo oracle-java10-installer shared/accepted-oracle-license-v1-1 select true \
    | sudo /usr/bin/debconf-set-selections
  
  echo oracle-java10-installer shared/accepted-oracle-licence-v1-1 boolean true \
    | sudo /usr/bin/debconf-set-selections
}


# ---------------------------
# ADD DEB PACKAGES
# ---------------------------


deb_installed+=(/usr/bin/slack)
deb_sources+=("https://downloads.slack-edge.com/linux_releases/slack-desktop-3.1.0-amd64.deb")

deb_installed+=(/usr/bin/discord)
deb_sources+=("https://discordapp.com/api/download?platform=linux&format=deb")


# ---------------------------
# INSTALL APT KEYS
# ---------------------------


print_header "Adding APT keys (${#apt_keys[@]})"

keys_cache=$DOTFILES/caches/init/apt_keys
IFS=$'\n' GLOBIGNORE='*' command eval 'setdiff_cur=($(<$keys_cache))'

setdiff_new=("${apt_keys[@]}"); setdiff; apt_keys=("${setdiff_out[@]}")
unset setdiff_cur setdiff_new setdiff_out

if (( ${#apt_keys[@]} > 0 )); then

  install_apt_keys

fi


# ---------------------------
# INSTALL APT SOURCES
# ---------------------------

print_header "Adding APT sources (${#source_i[@]})"

function __temp() { [[ ! -e /etc/apt/sources.list.d/$1.list ]]; }
source_i=($(array_filter_i apt_source_files __temp))

if (( ${#source_i[@]} > 0 )); then
 
  install_apt_sources

fi


# ---------------------------
# Update APT
# ---------------------------


print_header "Updating packages"

execute \
  "sudo apt-get -qq update" \
  "apt-get update"

# Only do a dist-upgrade on initial install, otherwise do an upgrade.
if is_dotfiles_bin; then

  execute \
    "sudo apt-get -qqy upgrade" \
    "apt-get upgrade"

else

  execute \
    "sudo apt-get -qqy dist-upgrade" \
    "apt-get dist-upgrade"

fi


# ---------------------------
# Update APT
# ---------------------------


print_header "Installing APT packages (${#apt_packages[@]})"

installed_apt_packages="$(dpkg --get-selections | grep -v deinstall | awk 'BEGIN{FS="[\t:]"}{print $1}' | uniq)"
apt_packages=($(setdiff "${apt_packages[*]}" "$installed_apt_packages"))

if (( ${#apt_packages[@]} > 0 )); then

  install_apt_packages

fi


# ---------------------------
# INSTALL DEBS VIA DPKG
# ---------------------------


print_header "Installing debs (${#deb_installed_i[@]})"

function __temp() { [[ ! -e "$1" ]]; }
deb_installed_i=($(array_filter_i deb_installed __temp))

if (( ${#deb_installed_i[@]} > 0 )); then

  install_debs

fi

# Run anything else that may need to be run.
type -t other_stuff >/dev/null && other_stuff
