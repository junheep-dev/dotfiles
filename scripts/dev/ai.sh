#!/bin/zsh

print_header "Claude Code"

print_step "Install Claude Code"
curl -fsSL https://claude.ai/install.sh | bash

print_step "Create configuration"
mkdir -p $HOME/.claude/hooks
cp "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
ln -sf "$DOTFILES_DIR/claude/hooks/notify.sh" "$HOME/.claude/hooks/notify.sh"
ln -sf "$DOTFILES_DIR/claude/hooks/notify-core.sh" "$HOME/.claude/hooks/notify-core.sh"
ln -sf "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

print_success "Claude Code setup complete"

print_header "Codex CLI"

print_step "Install Codex CLI"
brew install codex

print_step "Create configuration"
mkdir -p $HOME/.codex/hooks
ln -sf "$DOTFILES_DIR/codex/hooks/notify.sh" "$HOME/.codex/hooks/notify.sh"
# notify-core.sh is shared; keep the canonical copy under claude/hooks
ln -sf "$DOTFILES_DIR/claude/hooks/notify-core.sh" "$HOME/.codex/hooks/notify-core.sh"
# config.toml holds machine-specific project trust, so it isn't symlinked; just
# ensure the notify hook is registered. `notify` is a root key, so it must
# precede any [table] section — prepend it to stay valid TOML.
CODEX_CONFIG="$HOME/.codex/config.toml"
touch "$CODEX_CONFIG"
if ! grep -q '^notify' "$CODEX_CONFIG"; then
  CODEX_TMP=$(mktemp)
  {
    printf 'notify = ["bash", "%s/.codex/hooks/notify.sh"]\n' "$HOME"
    cat "$CODEX_CONFIG"
  } > "$CODEX_TMP" && mv "$CODEX_TMP" "$CODEX_CONFIG"
fi

print_success "Codex CLI setup complete"
