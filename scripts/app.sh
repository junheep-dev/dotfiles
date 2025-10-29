#!/bin/zsh

print_section "Install other apps"

# Apps
print_header "1Password"
brew install --cask 1password
print_header "Chrome"
brew install --cask google-chrome
print_header "Arc"
brew install --cask arc
print_header "Raycast"
brew install --cask raycast
print_header "Notion Calendar"
brew install --cask notion-calendar
print_header "VS code"
brew install --cask visual-studio-code
print_header "Logseq"
brew install --cask logseq
print_header "Claude Desktop"
brew install --cask claude
print_header "Spotify"
brew install --cask spotify

# Skip personal apps in work mode
if [[ "$WORK_MODE" != "true" ]]; then
  print_header "HEY"
  brew install --cask hey
fi

# MAS
print_header "MAS"
brew install mas
print_header "Kakaotalk"
mas install 869223134
print_header "Things 3"
mas install 904280696

print_success "All other apps are installed. You have to set up these apps manually."
