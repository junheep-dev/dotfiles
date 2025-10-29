#!/bin/zsh

print_header "Tmux"

print_step "Install Tmux"
brew install tmux

print_step "Create configuration symlinks"
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$HOME/.tmux"
ln -sf "$DOTFILES_DIR/tmux/.tmux.theme.conf" "$HOME/.tmux/.tmux.theme.conf"

print_step "Install Tmux Plugin Manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

print_step "Install tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins

tmux source ~/.tmux.conf

print_success "Tmux setup complete"
