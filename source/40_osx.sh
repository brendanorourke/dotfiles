# Abort if not OSX
is_ubuntu || return 1

# Use exa in place of ls if installed
if command -v exa >/dev/null 2>&1; then
    alias l="exa -lh --git"
    alias ls="exa"
    alias la="exa -lah --git"
    alias lt="exa -lRT --git"
    alias lta="exa -laRT --git"
fi
