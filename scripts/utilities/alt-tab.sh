#!/bin/zsh

print_header "AltTab"

print_step "Install AltTab"
brew install --cask alt-tab

# To print current preference: defaults read com.lwouis.alt-tab-macos
print_step "Set configurations"
defaults write com.lwouis.alt-tab-macos holdShortcut ⌘
defaults write com.lwouis.alt-tab-macos holdShortcut2 ⌘
defaults write com.lwouis.alt-tab-macos spacesToShow 1
defaults write com.lwouis.alt-tab-macos screensToShow 1
defaults write com.lwouis.alt-tab-macos showWindowlessApps 1
defaults write com.lwouis.alt-tab-macos spacesToShow2 1
defaults write com.lwouis.alt-tab-macos screensToShow2 1
defaults write com.lwouis.alt-tab-macos showWindowlessApps2 1
defaults write com.lwouis.alt-tab-macos windowDisplayDelay 150

print_step "Allow security permissions"
echo -n "Press Enter to open AltTab. Then grant the required permissions."
read -r
open -a "AltTab"
confirm_action "Have you completed granting permissions? Press 'y' and Enter to continue... "

print_success "AltTab setup complete"
