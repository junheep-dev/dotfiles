#!/bin/zsh

print_header "Claude Code"

print_step "Install Claude Code"
curl -fsSL https://claude.ai/install.sh | bash

print_step "Create configuration"
mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES_DIR/agents/hooks/agent-status" "$HOME/.local/bin/agent-status"
mkdir -p "$HOME/.claude/hooks"
# settings.json is not symlinked - Claude Code rewrites it - so sync.sh merges
# the managed keys into it instead.
ln -sf "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
for legacy_hook in \
  "$HOME/.claude/hooks/notify.sh" \
  "$HOME/.claude/hooks/notify-core.sh" \
  "$HOME/.codex/hooks/notify.sh" \
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
mkdir -p "$HOME/.codex"
# config.toml is not symlinked - Codex rewrites it - so sync.sh merges the
# managed keys into it instead.
ln -sf "$DOTFILES_DIR/codex/hooks.json" "$HOME/.codex/hooks.json"
ln -sf "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
# skills are shared with Codex via the Agent Skills standard directory
mkdir -p "$HOME/.agents/skills"
for skill in "$DOTFILES_DIR"/agents/skills/*/; do
  ln -sfn "${skill%/}" "$HOME/.agents/skills/$(basename "$skill")"
done
print_success "Codex CLI setup complete"
