# Abort if not Ubuntu
is_ubuntu || return 1

$BIN=/usr/local/bin

# Package management
alias update="sudo apt-get -qq update && sudo apt-get upgrade"
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
alias search="apt-cache search"

# Clipboard management
alias pbcopy='xclip -i -selection clipboard'
alias pbpaste='xclip -o -selection clipboard'

if [ -f $BIN/exa-linux-x86_64 ]; then
    ln -s $BIN/exa-linux-x86_64 $BIN/exa
fi