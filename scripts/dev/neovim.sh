#!/bin/zsh

print_header "Neovim"

print_step "Install neovim"
brew install neovim

print_step "Create configuration symlinks"
mkdir -p $HOME/.config
rm -rf $HOME/.config/nvim
ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

print_step "Install fzf, ripgrep, fd for fzf-lua"
brew install fzf
brew install ripgrep
brew install fd

print_step "Install imagemagick for snacks.nvim image"
brew install imagemagick

print_success "Neovim setup complete"
