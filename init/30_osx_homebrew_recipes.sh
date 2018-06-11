# Abort if not OSX
is_osx || return 1

# Exit if homebrew is not installed
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Homebrew recipes
recipes=(
    awscli
    coreutils
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
