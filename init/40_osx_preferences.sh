# Abort if not OSX
is_osx || return 1

PREFIX="Set Preferences: "

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# CHROME
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_header $PREFIX"Chrome"

execute "defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false" \
    "Disable backswipe"

execute "defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true" \
    "Expand print dialog by default"

killall "Google Chrome" &> /dev/null

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# FINDER
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_header $PREFIX"Finder"

execute "defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true && \
         defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true && \
         defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true" \
    "Automatically open a new Finder window when a volume is mounted"

execute "defaults write com.apple.finder _FXShowPosixPathInTitle -bool true" \
    "Use full POSIX path as window title"

execute "defaults write com.apple.finder DisableAllAnimations -bool true" \
    "Disable all animations"

execute "defaults write com.apple.finder WarnOnEmptyTrash -bool false" \
    "Disable the warning before emptying the Trash"

execute "defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'" \
    "Search the current directory by default"

execute "defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false" \
    "Disable warning when changing a file extension"

execute "defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true && \
         defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true && \
         defaults write com.apple.finder ShowMountedServersOnDesktop -bool true && \
         defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true" \
    "Show icons for hard drives, servers, and removable media on the desktop"

execute "defaults write -g AppleShowAllExtensions -bool true" \
    "Show all filename extensions"

killall "Finder" &> /dev/null

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# FIREFOX
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_header $PREFIX"Firefox"

execute "defaults write org.mozilla.firefox AppleEnableSwipeNavigateWithScrolls -bool false" \
    "Disable backswipe"

killall "firefox" &> /dev/null

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# KEYBOARD
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_header $PREFIX"Keyboard"

execute "defaults write -g AppleKeyboardUIMode -int 3" \
    "Enable full keyboard access for all controls"

execute "defaults write -g ApplePressAndHoldEnabled -bool false" \
    "Disable press-and-hold in favor of key repeat"

execute "defaults write -g 'InitialKeyRepeat_Level_Saved' -int 10" \
    "Set delay until repeat"

execute "defaults write -g KeyRepeat -int 1" \
    "Set the key repeat rate to fast"

execute "defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false" \
    "Disable smart quotes"

execute "defaults write -g NSAutomaticDashSubstitutionEnabled -bool false" \
    "Disable smart dashes"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# PHOTOS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_header $PREFIX"Photos"

execute "defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true" \
    "Prevent Photos from opening automatically when devices are plugged in"

killall "Photos" &> /dev/null

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# UI/UX
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_header $PREFIX"UI/UX"

execute "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true" \
   "Avoid creating '.DS_Store' files on network volumes"

execute "defaults write com.apple.CrashReporter UseUNC 1" \
    "Make crash reports appear as notifications"

execute "defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true" \
    "Automatically quit the printer app once the print jobs are completed"

execute "defaults write com.apple.screencapture disable-shadow -bool true" \
    "Disable shadow in screenshots"

execute "defaults write com.apple.screencapture location -string '$HOME/screenshots'" \
    "Save screenshots to ~/screnshots"

execute "defaults write com.apple.screencapture type -string 'png'" \
    "Save screenshots as PNGs"

execute "defaults write com.apple.screensaver askForPassword -int 1 && \
         defaults write com.apple.screensaver askForPasswordDelay -int 0"\
    "Require password immediately after into sleep or screen saver mode"

execute "defaults write -g AppleFontSmoothing -int 2" \
    "Enable subpixel font rendering on non-Apple LCDs"

execute "defaults write -g AppleShowScrollBars -string 'Always'" \
    "Always show scrollbars"

execute "defaults write -g NSDisableAutomaticTermination -bool true" \
    "Disable automatic termination of inactive apps"

execute "defaults write -g NSNavPanelExpandedStateForSaveMode -bool true" \
    "Expand save panel by default"

execute "defaults write -g NSTableViewDefaultSizeMode -int 2" \
    "Set sidebar icon size to medium"

execute "defaults write -g NSUseAnimatedFocusRing -bool false" \
    "Disable the over-the-top focus ring animation"

execute "defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false" \
    "Disable resume system-wide"

execute "defaults write -g PMPrintingExpandedStateForPrint -bool true" \
    "Expand print panel by default"

execute "sudo systemsetup -setrestartfreeze on" \
    "Restart automatically if the computer freezes"

killall "SystemUIServer" &> /dev/null
