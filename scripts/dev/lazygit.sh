#!/bin/zsh

print_header "Lazygit"

print_step "Install lazygit"
brew install lazygit

print_step "Create configuration symlinks"
mkdir -p "$HOME/Library/Application Support/lazygit"
rm -f "$HOME/Library/Application Support/lazygit/config.yml"
ln -sf "$DOTFILES_DIR/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"

print_success "Lazygit setup complete"
