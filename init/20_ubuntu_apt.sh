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
    fonts-powerline
    gdebi-core
    jupyter-core
    libc++1
    network-manager-openvpn
    paper-cursor-theme
    paper-icon-theme
    python-ipykernel
    python3
    python3-notebook
    python3-pip
    vim-gnome
    vlc
  )

  # https://github.com/tagplus5/vscode-ppa
  apt_keys+=(https://tagplus5.github.io/vscode-ppa/ubuntu/gpg.key)
  apt_source_files+=(vscode)
  apt_source_texts+=("deb https://tagplus5.github.io/vscode-ppa/ubuntu ./")
  apt_packages+=(code code-insiders)

  # https://www.spotify.com/us/download/linux/
  apt_keys+=('--keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90')
  apt_source_files+=(spotify)
  apt_source_texts+=("deb http://repository.spotify.com stable non-free")
  apt_packages+=(spotify-client)

fi


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ADD PACKAGE ARCHIVES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
