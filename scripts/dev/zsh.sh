#!/bin/zsh

print_header "Zsh"

print_step "Create configuration symlinks"
ln -sf "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

print_step "Install zsh plugins"
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
brew install powerlevel10k

print_success "Zsh setup complete"
