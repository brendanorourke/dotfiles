#!/usr/bin/env bash
[[ "$1" == "source" ]] || \

###########################################
# GENERAL PURPOSE EXPORTED VARS / FUNCTIONS
###########################################

# Various constants.
DEFAULT_USER="$(id -un)"
GITHUB_USER="brendanorourke"

# Where the magic happens.
export DOTFILES=~/.dotfiles

source utils.sh

# If this file was being sourced, exit now.
[[ "$1" == "source" ]] && return


###########################################
# COPY FILES
###########################################


function copy_header() { e_header "Copying files into home directory…"; }

function copy_test() {
  if [[ -e "$2" && ! "$(cmp "$1" "$2" 2> /dev/null)" ]]; then
    echo "same file"
  elif [[ "$1" -ot "$2" ]]; then
    echo "destination file newer"
  fi
}

function copy_do() {
  e_success "Copying ~/$1."
  cp "$2" ~/
}


###########################################
# LINK FILES
###########################################


function link_header() { e_header "Linking files into home directory…"; }

function link_test() {
  [[ "$1" -ef "$2" ]] && echo "same file"
}

function link_do() {
  e_success "Linking ~/$1."
  ln -sf "${2#$HOME/}" ~/
}


###########################################
# INSTALL SYSTEM REQUIRMENTS
###########################################

#
# Ensure that we can actually, like, compile anything.
#
if [[ ! "$(type -P gcc)" ]] && is_osx; then
  e_error "XCode or the Command Line Tools for XCode must be installed first."
  exit 1
fi

#
# If Git is not installed, install it
# Ubuntu only, since Git comes standard with recent XCode or CLT)
#
if [[ ! "$(type -P git)" ]] && is_ubuntu; then
  function git_header() { e_header "Installing git…"; }

  function git_install() {
    sudo apt-get -qq install git-core
  }

  install_stuff "git"
fi

#
# If curl is not installed, install it (Ubuntu only, curl standard on macOS)
#
if [[ ! "$(type -P curl)" ]] && is_ubuntu; then
  function curl_header() { e_header "Installing curl…"; }

  function curl_install() {
    sudo apt-get -qq install curl
  }

  install_stuff "curl"
fi

#
# Install vim bundles
#
function vimbundles_header() { e_header "Installing vim bundles…"; }

function vimbundles_install() {
  mkdir -p ~/.vim/bundle
  if [[ ! -e ~/.vim/bundle/vundle ]]; then
    git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  fi
  vim +BundleInstall! +BundleClean +qall 2&> /dev/null
}

#
# Install oh-my-zsh
#
function ohmyzsh_header() { e_header "Installing Oh My Zsh…"; }

function ohmyzsh_install() {
  curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh && \
  cp $DOTFILES/external/themes/bullet-train.zsh-theme ~/.oh-my-zsh/themes/bullet-train.zsh-theme
}


###########################################
# INITIALIZE DOTFILES
###########################################


if [[ ! -d $DOTFILES ]]; then
  e_header "Downloading dotfiles…"
  git clone --recursive git://github.com/$GITHUB_USER/dotfiles.git $DOTFILES
  cd $DOTFILES && e_success "download successful" || exit
elif [[ "$1" != "restart" ]]; then
  # Make sure we have the latest files.
  e_header "Updating dotfiles…"
  cd $DOTFILES || exit
  prev_head="$(git rev-parse HEAD)"
  git pull --recurse-submodules --quiet
  git submodule update --init --recursive
  if [[ "$(git rev-parse HEAD)" != "$prev_head" ]]; then
    e_header "Changes detected, restarting script"
    exec "$0" "restart"
  fi
  e_success "dotfiles updated"
fi

# Add binaries into the path
[[ -d $DOTFILES/bin ]] && PATH=$DOTFILES/bin:$PATH
export PATH

# Tweak file globbing.
shopt -s dotglob
shopt -s nullglob

# Create caches dir and init subdir, if they don't already exist.
mkdir -p "$DOTFILES/caches/init"

# If backups are needed, this is where they'll go.
backup_dir="$DOTFILES/backups/$(date "+%Y_%m_%d-%H_%M_%S")/"
backup=""

# Execute code for each file in these subdirectories.
do_stuff "copy"
do_stuff "link"

install_stuff "ohmyzsh"
install_stuff "vimbundles"

# Alert if backups were made.
if [[ "$backup" ]]; then
  echo -e "\nBackups were moved to ~/${backup_dir#$HOME/}"
fi
