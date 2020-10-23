# Abort if not OSX
is_osx || return 1

# Use exa in place of ls if installed
if command -v exa >/dev/null 2>&1; then
    alias l="exa -lh --git"
    alias ls="exa"
    alias la="exa -lah --git"
    alias lt="exa -lRT --git"
    alias lta="exa -laRT --git"
fi

# Set default Python3 to the version managed by Homebrew
# The macOS version of Python3 is totally broken
alias python3=/usr/local/bin/python3
