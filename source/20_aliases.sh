#
# Directory helpers
#
alias c="cdAndLs"
alias lsgrep="lsAndGrep"
alias mkdr="makeDirAndChange"

#
# Node helpers
#
alias npmclean="rm -rf ./node_modules && npm cache clean && npm install"

#
# Tmux helpers
#
alias tma="tmux a -s BRENDANOROURKE"
alias tmn="tmux new -s BRENDANOROURKE -n HipsterSh\#\%"
alias tmk="tmux kill-session"

# The fuck
eval $(thefuck --alias)
