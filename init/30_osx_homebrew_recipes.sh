# Abort if not OSX
is_osx || return 1

# Exit if homebrew is not installed
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# VARS AND CONSTS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


recipes=(
    awscli
    coreutils
    exa
    git
    git-extras
    neovim
    postgresql
    reattach-to-user-namespace
    thefuck
    tmux
    tmux-xpanes
    tree
    wget
)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# INSTALL HOMEBREW RECIPES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function brew_install_recipes() {

  recipes=($(setdiff "${recipes[*]}" "$(brew list)"))

  print_header "Installing Homebrew Recipes (${#recipes[@]})"

  if (( ${#recipes[@]} > 0 )); then

    for recipe in "${recipes[@]}"; do
      
      execute \
        "brew install $recipe" \
        "$recipe"
    
    done
  
  fi

}

brew_install_recipes
