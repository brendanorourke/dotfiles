# Ubuntu-only stuff. 
is_ubuntu || return 1


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# VARS AND CONSTS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


INSTALLERS_PATH="$DOTFILES/caches/installers"

zip_names=()
zip_urls=()


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ADD ZIP BINS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


zip_names+=("ngrok")
zip_urls+=("https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip")

zip_names+=("exa-linux-x86_64")
zip_urls+=("https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# UTILITY FUNCTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function install_from_zip() {
  
  local name=$1 url=$2 bins b zip tmp
  
  shift 2; bins=("$@"); [[ "${#bins[@]}" == 0 ]] && bins=($name)
  
  if [[ ! "$(which $name)" ]]; then
  
    mkdir -p "$INSTALLERS_PATH"
    zip="$INSTALLERS_PATH/$(echo "$url" | sed 's#.*/##')"
    wget -qO "$zip" "$url"
    tmp=$(mktemp -d)
    unzip "$zip" -d "$tmp"
  
    for b in "${bins[@]}"; do
  
      sudo cp "$tmp/$b" "/usr/local/bin/$(basename $b)"
  
    done
  
    rm -rf $tmp
    
  fi
  
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# INSTALL FROM ZIPS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


print_header "Installing bins from ZIP (${#zip_names[@]})"

for i in "${zip_urls[@]}"; do

    zip_name="${zip_names[i]}"
    zip_url="${zip_urls[i]}"

    execute \
        "install_from_zip $zip_name '$zip_url'" \
        "$zip_name"

done
