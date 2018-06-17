# Abort if not OSX
is_osx || return 1

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils"

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew to install." && return 1

# Tap Homebrew kegs.
function brew_tap_kegs() {
  
  kegs=($(setdiff "${kegs[*]}" "$(brew tap)"))
  
  if (( ${#kegs[@]} > 0 )); then
  
    for keg in "${kegs[@]}"; do
  
      brew tap $keg
  
    done
  
  fi
}

# Install Homebrew casks.
function brew_install_casks() {
  
  casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
  
  if (( ${#casks[@]} > 0 )); then
  
    e_header "Installing Homebrew casks: ${casks[*]}"
  
    for cask in "${casks[@]}"; do
  
      brew cask install $cask

    done
    
    brew cask cleanup
  
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
    iterm2
    karabiner-elements
    skype
    slack
    spotify
)

brew_install_casks
