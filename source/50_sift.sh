# Solutions Engineering @ Sift Science

if [ -f ~/.sift ]; then
    source ~/.sift
fi

##############
# Path Updates
##############

export PYTHONPATH="${PYTHONPATH}:$HOME/dev/SE_tools"

##############
# Aliases
##############

alias se="ssh $SE_MACHINE_USERNAME@$SE_MACHINE"

##############
# Functions
##############

# Copy files over SSH
function copy_to_se()   { scp $1 $SE_MACHINE_USERNAME@$SE_MACHINE:/home/$SE_MACHINE_USERNAME/$2; }
function copy_from_se() { scp $SE_MACHINE_USERNAME@$SE_MACHINE:/home/$SE_MACHINE_USERNAME/$1 /Users/$DEFAULT_USER/Desktop; }
