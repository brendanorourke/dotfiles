# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration
DEFAULT_USER="$(id -un)"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
BULLETTRAIN_TIME_BG="black"
BULLETTRAIN_TIME_FG="white"
ZSH=~/.oh-my-zsh
ZSH_THEME="bullet-train"

# Temporary fix for git info issue with zsh-themes
# NOTE: Must be included before oh-my-zsh is sourced.
# https://github.com/caiogondim/bullet-train.zsh/issues/348
zstyle ':omz:alpha:lib:git' async-prompt no

source $ZSH/oh-my-zsh.sh

# Load Node Version Manager
# https://github.com/creationix/nvm
NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Where the magic happens.
export DOTFILES=~/.dotfiles

# Add binaries into the path
PATH=$DOTFILES/bin:$PATH
export PATH

# Add golang to path
export PATH=$PATH:/home/$DEFAULT_USER/.go/bin
export GOPATH=/home/$DEFAULT_USER/go
export PATH=$PATH:/home/$DEFAULT_USER/go/bin

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
    for file in $DOTFILES/source/*; do
      source "$file"
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

src
