# Backups, swaps and undos are stored here.
mkdir -p $DOTFILES/caches/vim

# Download Vim plugins.
if [[ "$(type -P vim)" ]]; then
  mkdir -p ~/.vim/bundle
  if [[ ! -e ~/.vim/bundle/vundle ]]; then
    git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  fi
  vim +BundleInstall! +BundleClean +qall 2&> /dev/null
fi
