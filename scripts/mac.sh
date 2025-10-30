#!/bin/zsh

print_section "Mac system settings"

print_header "Keyboard settings"
print_step "Set faster key repeat rate and disable press-and-hold"
defaults write -g InitialKeyRepeat -int 15 # Normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 2         # Normal minimum is 2 (30 ms)
defaults write -g ApplePressAndHoldEnabled -bool false # Disable press and hold for keys

print_step "Remap ₩ key to backtick (\`)"
mkdir -p ~/Library/KeyBindings
cat << EOF > ~/Library/KeyBindings/DefaultkeyBinding.dict
{
    "₩" = ("insertText:", "\`");
    "~4" = ("insertText:", "₩");
}
EOF

print_header "Dock settings"
print_step "Remove all apps, enable auto-hide, and set icon size"
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -float 55
killall Dock

print_header "Hot Corners"
print_step "Set bottom-right corner to activate screen saver"
defaults write com.apple.dock wvous-br-corner -int 5

print_header "Finder"
print_step "Hide tags section in Finder sidebar"
defaults write com.apple.finder ShowRecentTags -bool false

print_success "Mac system settings setup complete"
