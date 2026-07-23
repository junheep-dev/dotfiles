#!/bin/bash
# Codex CLI notification hook for tmux + Ghostty
#
# Codex calls this via config.toml `notify = ["bash", ".../notify.sh"]` and
# passes the event payload as a single JSON argument ($1). Only the
# `agent-turn-complete` event exists today — that is the "look at me" moment,
# equivalent to Claude Code's Notification hook.
#
# The pane-focus-in hook (which clears the "!" marker) is re-registered on every
# turn instead of at session start, so no SessionStart equivalent is needed.
# tmux calls this back as `notify.sh --unmark <pane>`.

[ -z "$TMUX" ] && exit 0
source "$(dirname "$0")/notify-core.sh"

# Invoked by the tmux pane-focus-in hook to clear the marker.
if [ "$1" = "--unmark" ]; then
  nc_unmark "$2"
  exit 0
fi

pane="$TMUX_PANE"
[ -z "$pane" ] && exit 0

message=$(printf '%s' "$1" | jq -r '.["last-assistant-message"] // empty' | head -1)

nc_register_focus_hook "$pane" "$0" "--unmark"
nc_notify "$pane" "$message" "Codex"
