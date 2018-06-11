# Abort if not Ubuntu
is_ubuntu || return 1

# Package management
alias update="sudo apt-get -qq update && sudo apt-get upgrade"
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
alias search="apt-cache search"

# Clipboard management
alias pbcopy='xclip -i -selection clipboard'
alias pbpaste='xclip -o -selection clipboard'

# Use exa in place of ls if installed
if command -v exa-linux-x86_64 >/dev/null 2>&1; then
    alias l="exa-linux-x86_64 -l --git"
    alias ls="exa-linux-x86_64"
    alias la="exa-linux-x86_64 -la --git"
    alias lt="exa-linux-x86_64 -lRT --git"
    alias lta="exa-linux-x86_64 -laRT --git"
fi
