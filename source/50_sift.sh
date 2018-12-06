# Solutions Engineering @ Sift Science

# ----------------
# Load Env Vars
# ----------------

SIFT_CONFIG=~/.sift

if [ -f $SIFT_CONFIG ]; then
    source $SIFT_CONFIG
    export $(cut -d= -f1 $SIFT_CONFIG)
fi


# ----------------
# Path Updates
# ----------------

export PYTHONPATH="${PYTHONPATH}:$HOME/dev/sift/SE_tools"


# ----------------
# Aliases
# ----------------

alias se="ssh $SE_MACHINE_USERNAME@$SE_MACHINE"


# ----------------
# Functions
# ----------------

# Copy files over SSH
function copy_to_se()   { scp $1 $SE_MACHINE_USERNAME@$SE_MACHINE:/home/$SE_MACHINE_USERNAME/$2; }
function copy_from_se() { scp $SE_MACHINE_USERNAME@$SE_MACHINE:/home/$SE_MACHINE_USERNAME/$1 /Users/$DEFAULT_USER/Desktop; }
