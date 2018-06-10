#!/usr/bin/env bash

###########################################
# CONSTANTS
###########################################

EXCEPTION=101

###########################################
# LOGGING
###########################################

function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[00;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[00;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[00;34m➜\033[0m  $@"; }

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
# Test if the dotfiles script is currently
#
function is_dotfiles_running() {
  [[ "$DOTFILES_SCRIPT_RUNNING" ]] || return 1
}

#
# Test if this script was run via the "dotfiles" bin script (vs. via curl/wget)
#
function is_dotfiles_bin() {
  [[ "$(basename $0 2>/dev/null)" == dotfiles ]] || return 1
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

function is_ubuntu_desktop() {
  dpkg -l ubuntu-desktop >/dev/null 2>&1 || return 1
}

function get_os() {
  for os in osx ubuntu ubuntu_desktop; do
    is_$os; [[ $? == "${1:-0}" ]] && echo $os
  done
}

#
# Display a fancy multi-select menu.
# Inspired by http://serverfault.com/a/298312
#
function prompt_menu() {
  local exitcode prompt choices nums i n
  exitcode=0
  if [[ "$2" ]]; then
    _prompt_menu_draws "$1"
    read -t $2 -n 1 -sp "Press ENTER or wait $2 seconds to continue, or press any other key to edit."
    exitcode=$?
    echo ""
  fi 1>&2
  if [[ "$exitcode" == 0 && "$REPLY" ]]; then
    prompt="Toggle options (Separate options with spaces, ENTER when done): "
    while _prompt_menu_draws "$1" 1 && read -rp "$prompt" nums && [[ "$nums" ]]; do
      _prompt_menu_adds $nums
    done
  fi 1>&2
  _prompt_menu_adds
}

function _prompt_menu_iter() {
  local i sel state
  local fn=$1; shift
  for i in "${!menu_options[@]}"; do
    state=0
    for sel in "${menu_selects[@]}"; do
      [[ "$sel" == "${menu_options[i]}" ]] && state=1 && break
    done
    $fn $state $i "$@"
  done
}

function _prompt_menu_draws() {
  e_header "$1"
  _prompt_menu_iter _prompt_menu_draw "$2"
}

function _prompt_menu_draw() {
  local modes=(error success)
  if [[ "$3" ]]; then
    e_${modes[$1]} "$(printf "%2d) %s\n" $(($2+1)) "${menu_options[$2]}")"
  else
    e_${modes[$1]} "${menu_options[$2]}"
  fi
}

function _prompt_menu_adds() {
  _prompt_menu_result=()
  _prompt_menu_iter _prompt_menu_add "$@"
  menu_selects=("${_prompt_menu_result[@]}")
}

function _prompt_menu_add() {
  local state i n keep match
  state=$1; shift
  i=$1; shift
  for n in "$@"; do
    if [[ $n =~ ^[0-9]+$ ]] && (( n-1 == i )); then
      match=1; [[ "$state" == 0 ]] && keep=1
    fi
  done
  [[ ! "$match" && "$state" == 1 || "$keep" ]] || return
  _prompt_menu_result=("${_prompt_menu_result[@]}" "${menu_options[i]}")
}

#
# Array mapper. Calls map_fn for each item ($1) and index ($2) in array, and
# prints whatever map_fn prints. If map_fn is omitted, all input array items
# are printed.
# Usage: array_map array_name [map_fn]
#
function array_map() {
  local __i__ __val__ __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\"\${$__arr__[__i__]}\"")"
    if [[ "$1" ]]; then
      "$@" "$__val__" $__i__
    else
      echo "$__val__"
    fi
  done
}

#
# Print bash array in the format "i <val>" (one per line) for debugging.
#
function array_print() { array_map $1 __array_print; }
function __array_print() { echo "$2 <$1>"; }

#
# Array filter. Calls filter_fn for each item ($1) and index ($2) in array_name
# array, and prints all values for which filter_fn returns a non-zero exit code
# to stdout. If filter_fn is omitted, input array items that are empty strings
# will be removed.
# Usage: array_filter array_name [filter_fn]
# Eg. mapfile filtered_arr < <(array_filter source_arr)
#
function array_filter() { __array_filter 1 "$@"; }

# Works like array_filter, but outputs array indices instead of array items.
function array_filter_i() { __array_filter 0 "$@"; }

# The core function. Wheeeee.
function __array_filter() {
  local __i__ __val__ __mode__ __arr__
  __mode__=$1; shift; __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\${$__arr__[__i__]}")"
    if [[ "$1" ]]; then
      "$@" "$__val__" $__i__ >/dev/null
    else
      [[ "$__val__" ]]
    fi
    if [[ "$?" == 0 ]]; then
      if [[ $__mode__ == 1 ]]; then
        eval echo "\"\${$__arr__[__i__]}\""
      else
        echo $__i__
      fi
    fi
  done
}

#
# Array join. Joins array ($1) items on string ($2).
#
function array_join() { __array_join 1 "$@"; }

# Works like array_join, but removes empty items first.
function array_join_filter() { __array_join 0 "$@"; }

# Core function for the above
function __array_join() {
  local __i__ __val__ __out__ __init__ __mode__ __arr__
  __mode__=$1; shift; __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\"\${$__arr__[__i__]}\"")"
    if [[ $__mode__ == 1 || "$__val__" ]]; then
      [[ "$__init__" ]] && __out__="$__out__$@"
      __out__="$__out__$__val__"
      __init__=1
    fi
  done
  [[ "$__out__" ]] && echo "$__out__"
}

#
# Do something n times.
#
function n_times() {
  local max=$1; shift
  local i=0; while [[ $i -lt $max ]]; do "$@"; i=$((i+1)); done
}

#
# Do something n times, passing along the array index.
#
function n_times_i() {
  local max=$1; shift
  local i=0; while [[ $i -lt $max ]]; do "$@" "$i"; i=$((i+1)); done
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
