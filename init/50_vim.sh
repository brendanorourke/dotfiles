#!/bin/bash

declare -r BUNDLE_DIR="$HOME/.vim/bundle"
declare -r VUNDLE_DIR="$HOME/.vim/bundle/vundle"
declare -r VUNDLE_GIT="http://github.com/gmarik/vundle.git"

print_header "Installing vim bundles"

# Backups, swaps and undos are stored here.
execute \
  "mkdir -p $DOTFILES/caches/vim" \
  "create /caches/vim"

# Download Vim plugins.
if [[ "$(type -P vim)" ]]; then
  
  mkdir -p $BUNDLE_DIR

  execute \
    "rm -rf '$VUNDLE_DIR' \
      && git clone --quiet '$VUNDLE_GIT' '$VUNDLE_DIR'" \
    "download vundle"
  
  execute \
    "vim +PluginInstall +qall 2&> /dev/null" \
    "install vim bundles"

  execute \
    "nvim +PluginInstall +qall 2&> /dev/null" \
    "install nvim bundles"

  execute \
    "nvim +UpdateRemotePlugins +qall 2&> /dev/null" \
    "update remote nvim plugins"

else

  print_error "vim not installed"

fi
