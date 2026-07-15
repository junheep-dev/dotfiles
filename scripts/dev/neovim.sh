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

print_step "Create ripgrep config symlink"
ln -sf "$DOTFILES_DIR/ripgrep/.ripgreprc" "$HOME/.ripgreprc"

print_step "Install tree-sitter-cli for nvim-treesitter parser builds"
brew install tree-sitter-cli

print_success "Neovim setup complete"
