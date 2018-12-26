#
# Directory helpers
#
alias cd="cdLs"
alias lsgrep="lsAndGrep"
alias mkdr="makeDirAndChange"

#
# Node helpers
#
alias npmclean="rm -rf ./node_modules && npm cache clean && npm install"

# The fuck
eval $(thefuck --alias)
