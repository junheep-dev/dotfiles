#!/bin/zsh

print_section "Development Tools"

source "$DOTFILES_DIR/scripts/dev/zsh.sh"
source "$DOTFILES_DIR/scripts/dev/git.sh"
source "$DOTFILES_DIR/scripts/dev/node.sh"
source "$DOTFILES_DIR/scripts/dev/ruby.sh"
source "$DOTFILES_DIR/scripts/dev/ghostty.sh"
source "$DOTFILES_DIR/scripts/dev/tmux.sh"
source "$DOTFILES_DIR/scripts/dev/neovim.sh"
source "$DOTFILES_DIR/scripts/dev/lazygit.sh"

print_header "Claude Code"
npm install -g @anthropic-ai/claude-code

print_header "GitHub CLI"
brew install gh

print_success "Development tools setup complete"
