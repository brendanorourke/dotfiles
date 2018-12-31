# Only run for Ubuntu
is_ubuntu || return 1

print_header "Running scripts"

execute \
  "sudo sh $DOTFILES/scripts/install_polybar.sh" \
  "polybar"
