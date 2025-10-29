#!/bin/zsh

print_header "Hammerspoon"

print_step "Install Hammerspoon"
brew install --cask hammerspoon

print_step "Create configuration symlinks"
mkdir -p "$HOME/.hammerspoon"
rm -f $HOME/.hammerspoon/init.lua
ln -sf "$DOTFILES_DIR/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"

print_step "Allow security permissions"
echo -n "Press Enter to open Hammerspoon. Then grant the required permissions."
read -r
open -a "Hammerspoon"
confirm_action "Have you completed granting permissions? Press 'y' and Enter to continue... "

print_success "Hammerspoon setup complete"
