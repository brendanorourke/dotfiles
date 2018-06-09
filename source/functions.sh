#
# Simple success/fail prettifiers
#
function fail() {
  printf "\r\033[2K [\033[0;31mFAIL\033[0m] $1\n]]]"
  exit 1
}

function success() {
  printf "\r\033[2K [\033[00;32mOK\033[0m ] $1\n]]]"
}

#
# Check if command is installed
#
function check_install() {
  if ! type "$1" > /dev/null; then
    fail "Please install $1..."
  fi
}

#
# Various convenience functions for navigation
#
function makeDirAndChange () {
  mkdir $1
  cd $1
}

function lsAndGrep () {
  ls -lAh | grep $1
}

#
# Copy files over SSH
#
function copy_to_se() {
  scp $1 $SE_MACHINE_USERNAME@$SE_MACHINE:/home/$SE_MACHINE_USERNAME/$2
}

function copy_from_se() {
  scp $SE_MACHINE_USERNAME@$SE_MACHINE:/home/$SE_MACHINE_USERNAME/$1 /Users/$DEFAULT_USER/Desktop
}
