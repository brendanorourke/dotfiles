# Abort if not OSX
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && print_error "brew casks require homebrew to install." && return 1


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# VARS AND CONSTS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


kegs=(
    caskroom/cask
    caskroom/fonts
)

casks=(
    docker
    firefox
    font-fire-code
    font-menlo-for-powerline
    font-meslo-for-powerline
    iterm2
    karabiner-elements
    skype
    slack
    spotify
)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# TAP HOMEBREW KEGS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function brew_tap_kegs() {

  kegs=($(setdiff "${kegs[*]}" "$(brew tap)"))

  print_header "Tapping Homebrew Keys (${#kegs[@]})"

  if (( ${#kegs[@]} > 0 )); then
    
    for keg in "${kegs[@]}"; do

      execute \
        "brew tap $keg &>/dev/null" \
        "$keg"

    done
    
  fi

}

brew_tap_kegs


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# INSTALL HOMEBREW CASKS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# Show password prompt up-front
brew cask info this-is-somewhat-annoying 2>/dev/null

function brew_install_casks() {
  
  casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
  
  print_header "Installing Homebrew Casks (${#casks[@]})"

  if (( ${#casks[@]} > 0 )); then
  
    for cask in "${casks[@]}"; do
  
      execute \
        "brew cask install $cask &>/dev/null" \
        "$cask"

    done
    
    execute \
        "brew cask cleanup &>/dev/null" \
        "cleanup"
  
  fi

}

brew_install_casks
