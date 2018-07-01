# Solutions Engineering @ Sift Science

if [ -f ~/.sift ]; then
    source ~/.sift
fi


# ----------------
# Export Variables
# ----------------
export SE_MACHINE=$SE_MACHINE
export SE_MACHINE_USERNAME=$SE_MACHINE_USERNAME
export SIFT_ACCOUNT_ID=$SIFT_ACCOUNT_ID
export SIFT_REST_KEY=$SIFT_REST_KEY


# ----------------
# Path Updates
# ----------------
export PYTHONPATH="${PYTHONPATH}:$HOME/dev/SE_tools"


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
