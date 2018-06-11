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

source $(dirname $0)/utils.sh

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
# INITIALIZE SYSTEM
###########################################


DOTFILES_SCRIPT_RUNNING=1

function cleanup {
  unset DOTFILES_SCRIPT_RUNNING
}

trap cleanup EXIT

# Initialize.
init_file=$DOTFILES/caches/init/selected

function init_files() {
  local i f dirname oses os opt remove
  dirname="$(dirname "$1")"
  f=("$@")
  menu_options=(); menu_selects=()
  for i in "${!f[@]}"; do menu_options[i]="$(basename "${f[i]}")"; done
  if [[ -e "$init_file" ]]; then
    # Read cache file if possible
    IFS=$'\n' read -d '' -r -a menu_selects < "$init_file"
  else
    # Otherwise default to all scripts not specifically for other OSes
    oses=($(get_os 1))
    for opt in "${menu_options[@]}"; do
      remove=
      for os in "${oses[@]}"; do
        [[ "$opt" =~ (^|[^a-z])$os($|[^a-z]) ]] && remove=1 && break
      done
      [[ "$remove" ]] || menu_selects=("${menu_selects[@]}" "$opt")
    done
  fi
  prompt_menu "Run the following init scripts?" $prompt_delay
  # Write out cache file for future reading.
  rm "$init_file" 2>/dev/null
  for i in "${!menu_selects[@]}"; do
    echo "${menu_selects[i]}" >> "$init_file"
    echo "$dirname/${menu_selects[i]}"
  done
}

function init_do() {
  e_header "Sourcing $(basename "$2")…"
  source "$2"
}

###########################################
# DO STUFF!
###########################################

# Set the prompt delay to be longer for the very first run.
export prompt_delay=5; is_dotfiles_bin || prompt_delay=15

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
# Note that this doesn't work with Homebrew, since brew explicitly invalidates
# the sudo timestamp, which is probably wise.
# See https://gist.github.com/cowboy/3118588
while true; do sudo -n true; sleep 10; kill -0 "$$" || exit; done 2>/dev/null &

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
# Install oh-my-zsh
#
function ohmyzsh_header() { e_header "Installing Oh My Zsh…"; }

function ohmyzsh_install() {
  curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh && \
  cp $DOTFILES/external/themes/bullet-train.zsh-theme ~/.oh-my-zsh/themes/bullet-train.zsh-theme
}

#
# Initialize DOTFILES
#
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
do_stuff "init"

install_stuff "ohmyzsh"

# Alert if backups were made.
if [[ "$backup" ]]; then
  echo -e "\nBackups were moved to ~/${backup_dir#$HOME/}"
fi

# Complete
e_header "dotfiles execution complete!"