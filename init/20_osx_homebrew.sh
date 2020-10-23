# OSX-only stuff. Abort if not OSX.
is_osx || return 1

print_header "Running homebrew health checks"

# Install Homebrew if not already installed
if [[ ! "$(type -P brew)" ]]; then
  
  execute \
    "true | /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)\"" \
    "install homebrew"

fi

# Exit if, for some reason, Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && print_error "homebrew not installed" && return 1

execute \
  "brew doctor &>/dev/null" \
  "brew doctor"

execute \
  "brew update &>/dev/null" \
  "brew update"
