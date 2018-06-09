# Current user name, to be used in absolute pathing
export DEFAULT_USER="$(id -un)"

# Enable 256-colors for terminal theme
export TERM="xterm-256color"

# Solutions Engineering @ Sift Science
export PYTHONPATH="${PYTHONPATH}:$HOME/dev/SE_tools"

# Set Node Path
export PATH="$HOME/.node/bin:$PATH"

# Add NVM directory for Node version management.
export NVM_DIR="$HOME/.nvm"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
