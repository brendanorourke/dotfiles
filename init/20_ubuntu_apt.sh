# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# VARS AND CONSTS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

apt_keys=()
apt_packages=()
apt_source_files=()
apt_source_texts=()

INSTALLERS_PATH="$DOTFILES/caches/installers"

# Ubuntu distro release name, eg. "xenial"
RELEASE_NAME=$(lsb_release -c | awk '{ print $2 }' | sed 's/[.]//')


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# HELPER FUNCTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function add_ppa() {
  
  apt_source_texts+=($1)
  
  IFS=':/' eval 'local parts=($1)'
  apt_source_files+=("${parts[1]}-ubuntu-${parts[2]}-$RELEASE_NAME")

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
        "sudo sh -c ""echo '$source_text' | sudo tee /etc/apt/sources.list.d/$source_file.list" \
        "$source_file"
  
    fi
  
  done

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ADD PACKAGES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


apt_packages+=(
  # Global packages
  awscli
  build-essential
  cmake
  cmake-data
  curl
  docker.io
  docker-compose
  git-core
  golang-go
  htop
  libappindicator1
  libasound2-dev
  libc++1
  libcairo2-dev
  libcurl4-openssl-dev
  libgconf-2-4
  libmpdclient-dev
  libnl-genl-3-dev
  libxcb1-dev
  libxcb-composite0-dev
  libxcb-cursor-dev
  libxcb-ewmh-dev
  libxcb-icccm4-dev
  libxcb-image0-dev
  libxcb-randr0-dev
  libxcb-util0-dev
  libxcb-xrm-dev
  nodejs
  npm
  pkg-config
  postgresql
  python-dev
  python-ipykernel
  python-pip
  python-xcbgen
  python3
  python3-dev
  python3-notebook
  python3-pip
  software-properties-common
  thefuck
  tmux
  vim
  # Desktop packages
  default-jdk
  fonts-firacode
  fonts-font-awesome
  fonts-powerline
  gconf2
  gconf-service
  gdebi-core
  gnome-tweak-tool
  jupyter-core
  network-manager-openvpn
  vim-gnome
  vlc
  xcb-proto
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# INSTALL APT KEYS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


keys_cache=$DOTFILES/caches/init/apt_keys

if [ -f $keys_cache ]; then

  IFS=$'\n' GLOBIGNORE='*' command eval 'setdiff_cur=($(<$keys_cache))'

fi

setdiff_new=("${apt_keys[@]}"); setdiff; apt_keys=("${setdiff_out[@]}")
unset setdiff_cur setdiff_new setdiff_out

print_header "Adding APT keys (${#apt_keys[@]})"

if (( ${#apt_keys[@]} > 0 )); then

  install_apt_keys

fi


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# INSTALL APT SOURCES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function __temp() { [[ ! -e /etc/apt/sources.list.d/$1.list ]]; }
source_i=($(array_filter_i apt_source_files __temp))

print_header "Adding APT sources (${#source_i[@]})"

if (( ${#source_i[@]} > 0 )); then
 
  install_apt_sources

fi


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Update APT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


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


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# INSTALL APT PACKAGES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


installed_apt_packages="$(dpkg --get-selections | grep -v deinstall | awk 'BEGIN{FS="[\t:]"}{print $1}' | uniq)"
apt_packages=($(setdiff "${apt_packages[*]}" "$installed_apt_packages"))

print_header "Installing APT packages (${#apt_packages[@]})"

if (( ${#apt_packages[@]} > 0 )); then

  install_apt_packages

fi
