# Current user name, to be used in absolute pathing
export DEFAULT_USER="$(id -un)"

# Enable 256-colors for terminal theme
export TERM="xterm-256color"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
export BULLETTRAIN_TIME_BG="black"
export BULLETTRAIN_TIME_FG="white"
export ZSH=/Users/$DEFAULT_USER/.oh-my-zsh
export ZSH_THEME="bullet-train"

# Sift Science
export PYTHONPATH="${PYTHONPATH}:$HOME/dev/SE_tools"

# Set Node Path
export PATH="$HOME/.node/bin:$PATH"

# Add NVM directory for Node version management.
export NVM_DIR="$HOME/.nvm"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
