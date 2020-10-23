set nocompatible

filetype on
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Bundles {
  " Dependencies
  Plugin 'gmarik/vundle'
  Plugin 'tomtom/tlib_vim'

  " General
  Plugin 'christoomey/vim-tmux-navigator'
  Plugin 'godlygeek/tabular'
  Plugin 'jistr/vim-nerdtree-tabs'
  Plugin 'kien/ctrlp.vim'
  Plugin 'myusuf3/numbers.vim'
  Plugin 'posva/vim-vue'
  Plugin 'rafi/awesome-vim-colorschemes'
  Plugin 'Raimondi/delimitMate'
  Plugin 'scrooloose/nerdtree'
  Plugin 'scrooloose/syntastic'
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
  Plugin 'vim-python/python-syntax'

  if !has('nvim')
    Plugin 'roxma/nvim-yarp'
    Plugin 'roxma/vim-hug-neovim-rpc'
  endif
" }

" General {
  filetype plugin indent on      " Automatically detect file types
  scriptencoding utf-8
  set t_Co=256
  set background=dark
  set backspace=indent,eol,start " Backspace for dummies
  set cursorline                 " Highlight current line
  set foldenable                 " Auto fold code
  set hidden                     " Buffer switching without saving
  set hlsearch                   " Highlight search term
  set ignorecase                 " Case insensitive search
  set incsearch                  " Search as you type
  set mouse=a                    " Automatically enable mouse
  set mousehide                  " Hide cursor while typing
  set nobackup
  set noswapfile
  set nowritebackup
  set nu                         " Line numbers
  set scrolljump=5               " Jump lines when cursor off screen
  set scrolloff=3                " Number of lines to keep around cursor
  set showmatch                  " Highlighting matching brackets
  set spell
  set virtualedit=onemore
  syntax on                      " Syntax highlighting
" }

" UI Settings {
  if filereadable(expand("~/.vim/bundle/awesome-vim-colorschemes/colors/deus.vim"))
    colors deus
  endif

  " Transparent background
  hi Normal ctermbg=None

  let g:airline_powerline_fonts=1
  let g:airline_theme='deus'
" }

" Formatting {
  set autoindent                 " Auto indent new lines
  set comments=sl:/*,mb:*,elx:*/ " Auto format comment blocks
  set expandtab                  " Tabs are spaces
  set shiftwidth=2               " Indent width of 2 spaces
" }

" Key (re)Mappings {
  let mapleader = ','

  " Easier movement between tabs/windows
  map <C-H> <C-W>h
  map <C-J> <C-W>j
  map <C-K> <C-W>k
  map <C-L> <C-W>l

  " Wrapped lines go up/down to next row, instead of line
  nnoremap j gj
  nnoremap k gk

  " Yank to end of line, consistent with C and D
  nnoremap Y y$
" }

" Plugin Settings {
  "CtrlP
  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_switch_buffer = 0
  let g:ctrlp_working_path_mode = 'r'
  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn$',
        \ 'file': '\.exe$\|\.so$\|\.dll$'
        \ }

  " Nerdtree
  nnoremap <leader>d :NERDTreeTabsToggle<CR>
  map <C-n> :NERDTreeToggle<CR>
  let NERDTreeIgnore = ['\.pyc$']
  let NERDTreeShowHidden = 1
  let g:NERDTreeNodeDelimiter = "\u00a0"
" }
