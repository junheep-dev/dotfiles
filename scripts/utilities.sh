#!/bin/zsh

print_section "Utilities"

source "$DOTFILES_DIR/scripts/utilities/karabiner.sh"
source "$DOTFILES_DIR/scripts/utilities/alt-tab.sh"
source "$DOTFILES_DIR/scripts/utilities/hammerspoon.sh"

print_header "MonitorControl"
brew install --cask monitorcontrol

print_header "Rectangle"
brew install --cask rectangle

print_header "Cleanshot"
brew install --cask cleanshot

print_header "Logi Options plus"
brew install --cask logi-options+

print_success "Utilities setup complete"
