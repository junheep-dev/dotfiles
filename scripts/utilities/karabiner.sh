#!/bin/zsh

print_header "Karabiner"

print_step "Install Karabiner"
brew install --cask karabiner-elements

print_step "Create configuration symlinks"
mkdir -p $HOME/.config
rm -rf $HOME/.config/karabiner
ln -sf "$DOTFILES_DIR/karabiner" "$HOME/.config/karabiner"

print_step "Allow security permissions"
echo -n "Press Enter to run Karabiner-Elements. Then grant the required permissions."
read -r
open -a "Karabiner-Elements"
confirm_action "Have you completed granting permissions? Press 'y' and Enter to continue... "

print_step "Set keyboard shortcuts in System settings"
echo "Please set the following keyboard shortcuts in System Settings > Keyboard > Keyboard Shortcuts:"
echo "1. Input Sources > Select the previous input source: F18"
confirm_action "Press 'y' and Enter when you have completed setting the shortcuts... "

print_success "Karabiner setup complete"
