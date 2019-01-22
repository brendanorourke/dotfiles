# Only run for Ubuntu
is_ubuntu || return 1

$SCRIPT_DIR="$DOTFILES/scripts"

print_header "Running scripts"

execute \
  "sudo sh $SCRIPT_DIR/polybar_install.sh" \
  "install polybar"

execute \
  "sudo sh $SCRIPT_DIR/adobe_font_install.sh" \
  "install adobe source code pro"

