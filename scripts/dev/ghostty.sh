#!/bin/zsh

print_header "Ghostty"

print_step "Install Ghostty"
brew install --cask ghostty

print_step "Create configuration symlinks"
mkdir -p $HOME/.config
rm -rf $HOME/.config/ghostty
ln -sf "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

print_step "Install CaskaydiaMono Nerd Font(Cascadia Code)"
brew install --cask font-caskaydia-mono-nerd-font
print_step "Install BlexMono Nerd Font(IBM Plex Mono)"
brew install --cask font-blexmono-nerd-font
print_step "Install D2Coding Font"
brew install --cask font-d2coding

print_success "Ghostty setup complete"
