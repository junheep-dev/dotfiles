#!/bin/zsh

print_header "Hammerspoon"

print_step "Install Hammerspoon"
brew install --cask hammerspoon

print_step "Create configuration symlinks"
mkdir -p "$HOME/.hammerspoon"
rm -f $HOME/.hammerspoon/init.lua
ln -sf "$DOTFILES_DIR/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"

print_success "Hammerspoon setup complete"
