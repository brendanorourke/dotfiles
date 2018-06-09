#!/usr/bin/env bash

###########################################
# CONSTANTS
###########################################

EXCEPTION=101

###########################################
# LOGGING
###########################################

function e_header()   { echo "\n\033[1m$@\033[0m"; }
function e_success()  { echo " \033[00;32m✔\033[0m  $@"; }
function e_error()    { echo " \033[00;31m✖\033[0m  $@"; }
function e_arrow()    { echo " \033[00;34m➜\033[0m  $@"; }

###########################################
# UTILITY FUNCTIONS
###########################################

#
# Try/Catch block functionality for bash
# https://stackoverflow.com/questions/22009364/is-there-a-try-catch-command-in-bash
#
function throw()        { exit $1; }
function throwErrors()  { set -e; }
function ignoreErrors() { set +e; }

function try() {
  [[ $- = *e* ]]; SAVED_OPT_E=$?
  set +e
}

function catch() {
  export ex_code=$?
  (( $SAVED_OPT_E )) && set +e
  return $ex_code
}

function safe_exec() {
  local func=${1}
  local name=${2}
  try
  (
    $func || throw $EXCEPTION
    e_success "$name successfully installed"
  )
  catch || {
    case $ex_code in
      $EXCEPTION)
        e_error "error installing $name"
        exit 1
      ;;
      *)
        e_error "an unexpected exception was thrown"
        exit 1
      ;;
    esac
  }
}

#
# Testing
#
function assert() {
  local success modes equals actual expected
  modes=(e_error e_success); equals=("!=" "=="); expected="$1"; shift
  actual="$("$@")"
  [[ "$actual" == "$expected" ]] && success=1 || success=0
  ${modes[success]} "\"$actual\" ${equals[success]} \"$expected\""
}

#
# OS detection
#
function is_osx() {
  [[ "$OSTYPE" =~ ^darwin ]] || return 1
}

function is_ubuntu() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1
}

function get_os() {
  for os in osx ubuntu; do
    is_$os; [[ $? == "${1:-0}" ]] && echo $os
  done
}

#
# Remove an entry from $PATH (http://stackoverflow.com/a/2108540/142339)
#
function path_remove() {
  local arg path
  path=":$PATH:"
  for arg in "$@"; do path="${path//:$arg:/:}"; done
  path="${path%:}"
  path="${path#:}"
  echo "$path"
}

#
# Given strings containing space-delimited words A and B, "setdiff A B" will
# return all words in A that do not exist in B.
# From (http://stackoverflow.com/a/1617303/142339)
#
function setdiff() {
  local debug skip a b
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  if [[ "$1" ]]; then
    local setdiffA setdiffB setdiffC
    setdiffA=($1); setdiffB=($2)
  fi
  setdiffC=()
  for a in "${setdiffA[@]}"; do
    skip=
    for b in "${setdiffB[@]}"; do
      [[ "$a" == "$b" ]] && skip=1 && break
    done
    [[ "$skip" ]] || setdiffC=("${setdiffC[@]}" "$a")
  done
  [[ "$debug" ]] && for a in setdiffA setdiffB setdiffC; do
    echo "$a ($(eval echo "\${#$a[*]}")) $(eval echo "\${$a[*]}")" 1>&2
  done
  [[ "$1" ]] && echo "${setdiffC[@]}"
}

###########################################
# EXECUTION FUNCTIONS
###########################################

#
# File based actions. E.g., copy, link, etc.
#
function do_stuff() {
  local base dest skip
  local files=($DOTFILES/$1/*)
  [[ $(declare -f "$1_files") ]] && files=($("$1_files" "${files[@]}"))
  # No files? abort.
  if (( ${#files[@]} == 0 )); then return; fi
  # Run _header function only if declared.
  [[ $(declare -f "$1_header") ]] && "$1_header"
  # Iterate over files.
  for file in "${files[@]}"; do
    base="$(basename "$file")"
    dest="$HOME/$base"
    # Run _test function only if declared.
    if [[ $(declare -f "$1_test") ]]; then
      # If _test function returns a string, skip file and print that message.
      skip="$("$1_test" "$file" "$dest")"
      if [[ "$skip" ]]; then
        e_arrow "Skipping ~/$base, $skip."
        continue
      fi
      # Destination file already exists in ~/. Back it up!
      if [[ -e "$dest" ]]; then
        e_success "Backing up ~/$base."
        # Set backup flag, so a nice message can be shown at the end.
        backup=1
        # Create backup dir if it doesn't already exist.
        [[ -e "$backup_dir" ]] || mkdir -p "$backup_dir"
        # Backup file / link / whatever.
        mv "$dest" "$backup_dir"
      fi
    fi
    # Do stuff.
    "$1_do" "$base" "$file"
  done
}

#
# Install actions. E.g., git, oh-my-zsh, etc.
#
function install_stuff() {
  [[ $(declare -f "$1_header") ]] && "$1_header"
  safe_exec "$1_install" $1
}
