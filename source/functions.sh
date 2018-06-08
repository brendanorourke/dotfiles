function prompt_context() {}

function prompt_go() {
  setopt extended_glob
  if [[ (-f *.go(#qN) || -d Godeps || -f glide.yaml) ]]; then
    if command -v go > /dev/null 2>&1; then
      prompt_segment $BULLETTRAIN_GO_BG $BULLETTRAIN_GO_FG $BULLETTRAIN_GO_PREFIX" $(go version | grep --colour=never -oE '\d+(\.\d+)+')"
    fi
  fi
}

function prompt_nvm() {
  if [[ (-f *.js(#qN) || -f *.json(#qN)) ]]; then
    local nvm_prompt
    if type nvm >/dev/null 2>&1; then
      nvm_prompt=$(nvm current 2>/dev/null)
      [[ "${nvm_prompt}x" == "x" ]] && return
    elif type node >/dev/null 2>&1; then
      nvm_prompt="$(node --version)"
    else
      return
    fi
    nvm_prompt=${nvm_prompt}
    prompt_segment $BULLETTRAIN_NVM_BG $BULLETTRAIN_NVM_FG $BULLETTRAIN_NVM_PREFIX$nvm_prompt
  fi
}

function prompt_ruby() {
  if [[ (-f *.rb(#qN) || -f *.ru(#qN) || -f Gemfile*(#qN)) ]]; then
    local ruby_prompt
    if type rvm >/dev/null 2>&1; then
      ruby_prompt=$(rvm current 2>/dev/null)
      [[ "${ruby_prompt}x" == "x" ]] && return
    elif type ruby >/dev/null 2>&1; then
      ruby_prompt="$(ruby --version)"
    else
      return
    fi
    ruby_prompt=${ruby_prompt}
    prompt_segment $BULLETTRAIN_RUBY_BG $BULLETTRAIN_RUBY_FG $BULLETTRAIN_RUBY_PREFIX"  "$ruby_prompt
  fi
}

function check_install() {
  if ! type "$1" > /dev/null; then
    fail "Please install $1..."
  fi
}

function fail() {
  printf "\r\033[2K [\033[0;31mFAIL\033[0m] $1\n]]]"
  exit 1
}

function success() {
  printf "\r\033[2K [\033[00;32mOK\033[0m ] $1\n]]]"
}

function makeDirAndChange () {
  mkdir $1
  cd $1
}

function lsAndGrep () {
  ls -lAh | grep $1
}

function copy_to_se() {
  scp $1 $SE_MACHINE_USERNAME@$SE_MACHINE:/home/$SE_MACHINE_USERNAME/$2
}

function copy_from_se() {
  scp $SE_MACHINE_USERNAME@$SE_MACHINE:/home/$SE_MACHINE_USERNAME/$1 /Users/$DEFAULT_USER/Desktop
}
