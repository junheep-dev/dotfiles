#!/bin/zsh

print_header "Claude Code"

print_step "Install Claude Code"
curl -fsSL https://claude.ai/install.sh | bash

print_step "Create configuration symlinks"
mkdir -p $HOME/.claude/hooks
ln -sf "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
ln -sf "$DOTFILES_DIR/claude/hooks/notify.sh" "$HOME/.claude/hooks/notify.sh"

print_success "Claude Code setup complete"
