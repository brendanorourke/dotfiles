# Abort if not OSX
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && print_error "brew casks require homebrew to install." && return 1

# Tap Homebrew kegs.
function brew_tap_kegs() {
  
  print_header "Tapping Homebrew Kegs"

  kegs=($(setdiff "${kegs[*]}" "$(brew tap)"))
  
  if (( ${#kegs[@]} > 0 )); then
  
    for keg in "${kegs[@]}"; do
  
      execute \
        "brew tap $keg &>/dev/null" \
        "$keg"
  
    done
  
  fi
}

# Install Homebrew casks.
function brew_install_casks() {
  
  casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
  
  if (( ${#casks[@]} > 0 )); then
  
    #e_header "Installing Homebrew casks: ${casks[*]}"
    print_header "Installing Homebrew Casks"

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

kegs=(
    caskroom/cask
    caskroom/fonts
)

brew_tap_kegs

# Show password prompt up-front
brew cask info this-is-somewhat-annoying 2>/dev/null

casks=(
    docker
    firefox
    font-menlo-for-powerline
    font-meslo-for-powerline
    iterm2
    karabiner-elements
    skype
    slack
    spotify
)

brew_install_casks
