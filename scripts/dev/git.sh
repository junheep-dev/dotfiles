#!/bin/zsh

print_header "Git config"

print_step "Create gitconfig symlinks"
rm -f $HOME/.gitconfig
ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

print_success "Git config setup complete"
