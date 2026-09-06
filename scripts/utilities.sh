#!/bin/zsh

print_section "Utilities"

source "$DOTFILES_DIR/scripts/utilities/karabiner.sh"
source "$DOTFILES_DIR/scripts/utilities/hammerspoon.sh"

print_header "AltTab"
brew install --cask alt-tab

print_header "MonitorControl"
brew install --cask monitorcontrol

print_header "Rectangle"
brew install --cask rectangle

print_header "Cleanshot"
brew install --cask cleanshot

print_header "Logi Options plus"
brew install --cask logi-options+

print_header "SoundSource"
brew install --cask soundsource

# Restores preferences for the apps above that store settings only in their
# defaults domain, then schedules the daily snapshot.
"$DOTFILES_DIR/prefs.sh" import
"$DOTFILES_DIR/prefs.sh" install-agent

print_success "Utilities setup complete"
