#!/bin/zsh

print_header "Claude Code"

print_step "Install Claude Code"
curl -fsSL https://claude.ai/install.sh | bash

print_step "Create configuration"
mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES_DIR/agents/hooks/agent-status" "$HOME/.local/bin/agent-status"
mkdir -p "$HOME/.claude/hooks"
claude_settings="$HOME/.claude/settings.json"
claude_settings_tmp=$(mktemp "$HOME/.claude/settings.XXXXXX")
if [[ -f "$claude_settings" ]]; then
  if ! jq -s '
    .[0] as $current
    | .[1] as $managed
    | $current * $managed
    | .hooks = $managed.hooks
  ' "$claude_settings" "$DOTFILES_DIR/claude/settings.json" >"$claude_settings_tmp"; then
    rm "$claude_settings_tmp"
    print_error "Failed to merge Claude Code settings"
    return 1
  fi
else
  if ! cp "$DOTFILES_DIR/claude/settings.json" "$claude_settings_tmp"; then
    rm "$claude_settings_tmp"
    print_error "Failed to prepare Claude Code settings"
    return 1
  fi
fi
if ! mv "$claude_settings_tmp" "$claude_settings"; then
  rm -f "$claude_settings_tmp"
  print_error "Failed to install Claude Code settings"
  return 1
fi
ln -sf "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
for legacy_hook in \
  "$HOME/.claude/hooks/notify.sh" \
  "$HOME/.claude/hooks/notify-core.sh" \
  "$HOME/.codex/hooks/notify-core.sh"; do
  [[ -L "$legacy_hook" ]] && rm "$legacy_hook"
done
ln -sf "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
mkdir -p "$HOME/.claude/skills"
for skill in "$DOTFILES_DIR"/agents/skills/*/; do
  ln -sfn "${skill%/}" "$HOME/.claude/skills/$(basename "$skill")"
done

print_success "Claude Code setup complete"

print_header "Codex CLI"

print_step "Install Codex CLI"
brew install codex

print_step "Create configuration"
mkdir -p "$HOME/.codex/hooks"
ln -sf "$DOTFILES_DIR/codex/hooks.json" "$HOME/.codex/hooks.json"
# Existing config.toml notify chains may still call this compatibility wrapper.
ln -sf "$DOTFILES_DIR/codex/hooks/notify.sh" "$HOME/.codex/hooks/notify.sh"
ln -sf "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
# skills are shared with Codex via the Agent Skills standard directory
mkdir -p "$HOME/.agents/skills"
for skill in "$DOTFILES_DIR"/agents/skills/*/; do
  ln -sfn "${skill%/}" "$HOME/.agents/skills/$(basename "$skill")"
done
print_success "Codex CLI setup complete"
