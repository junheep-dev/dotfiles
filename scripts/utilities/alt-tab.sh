#!/bin/zsh

print_header "AltTab"

print_step "Install AltTab"
brew install --cask alt-tab

# Shortcut keys are now stored as dicts with binary secureData,
# so we apply the full preferences snapshot instead of writing keys individually.
# To refresh: export from AltTab > Preferences > Misc > Export, save to alt-tab.plist,
# then strip MSAppCenter*/NSWindow Frame*/SU* transient keys.
print_step "Apply preferences"
killall AltTab 2>/dev/null
defaults import com.lwouis.alt-tab-macos "$DOTFILES_DIR/scripts/utilities/alt-tab.plist"

print_step "Allow security permissions"
echo -n "Press Enter to open AltTab. Then grant the required permissions."
read -r
open -a "AltTab"
confirm_action "Have you completed granting permissions? Press 'y' and Enter to continue... "

print_success "AltTab setup complete"
