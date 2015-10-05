root_dir := $(shell pwd)
vim_bundle_dir = $(HOME)/.vim/bundle
vundle = $(HOME)/.vim/bundle/vundle
dotfiles = $(HOME)/.dotfiles
vimrc = $(HOME)/.vimrc
bin_dir = /usr/local/bin
brew = $(bin_dir)/brew
tmux = $(bin_dir)/tmux
zsh = $(bin_dir)/zsh

vimbundles: $(vimrc) $(vundle)
	vim +BundleInstall! +BundleClean +qall

oh-my-zsh:
	curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

symlinks: $(dotfiles) $(tmux) oh-my-zsh
	$(root_dir)/scripts/symlink_dotfiles

$(dotfiles): $(root_dir)
	rm -rf $(dotfiles)
	ln -s $(root_dir) $(dotfiles)

$(vim_bundle_dir):
	mkdir -p $(vim_bundle_dir)

$(vundle): $(vim_bundle_dir)
	git clone http://github.com/gmarik/vundle.git $(vundle)

$(vimrc): symlinks

reattach-to-user-namespace: $(brew)
	brew install reattach-to-user-namespace

$(brew):
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

$(tmux): $(brew) reattach-to-user-namespace
	brew install tmux

clean:
	rm -rf $(HOME)/.vim
	rm -rf $(HOME)/.oh-my-zsh
	rm $(HOME)/.vimrc
	rm $(HOME)/.tmux.conf
	rm $(HOME)/.zshrc
	rm $(HOME)/.dotfiles
