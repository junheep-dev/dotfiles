#!/bin/zsh

print_header "btop"

print_step "Install btop"
brew install btop

print_step "Create configuration symlinks"
mkdir -p $HOME/.config
rm -rf $HOME/.config/btop
ln -sf "$DOTFILES_DIR/btop" "$HOME/.config/btop"

print_success "btop setup complete"
