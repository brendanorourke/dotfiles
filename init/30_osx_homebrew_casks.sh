# Abort if not OSX
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew to install." && return 1

kegs=(
    caskroom/cask
    caskroom/fonts
)

brew_tap_kegs

# Show password prompt up-front
brew cask info this-is-somewhat-annoying 2>/dev/null

casks=(
    # Applications
    #docker
    #firefox
    #iterm2
    karabiner-elements
    skype
    #slack
    #spotify
    # Fonts
    font-m-plus
    font-mplus-nerd-font
    font-mplus-nerd-font-mono
)

brew_install_casks
