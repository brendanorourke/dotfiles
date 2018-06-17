# Abort if not OSX
is_osx || return 1

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils"

# Exit if homebrew is not installed
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Install Homebrew recipes.
function brew_install_recipes() {

  recipes=($(setdiff "${recipes[*]}" "$(brew list)"))

  if (( ${#recipes[@]} > 0 )); then
    
    #e_header "Installing Homebrew recipes: ${recipes[*]}"
    for recipe in "${recipes[@]}"; do
      
      brew install $recipe
      #e_success "$recipe installed"
    
    done
  
  fi

}

# Homebrew recipes
recipes=(
    awscli
    coreutils
    exa
    git
    git-extras
    postgresql
    reattach-to-user-namespace
    thefuck
    tmux
    tmux-xpanes
    tree
    wget
)

brew_install_recipes
