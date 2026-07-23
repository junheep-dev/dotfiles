#!/bin/bash
# Shared tmux + Ghostty notification core for AI agent CLIs.
# Sourced by claude/hooks/notify.sh and codex/hooks/notify.sh.

# Clear the "!" attention marker from a window.
nc_unmark() {
  local pane="$1"
  [ -z "$pane" ] && return
  local current
  current=$(tmux display-message -t "$pane" -p '#W')
  tmux rename-window -t "$pane" "${current%!}"
}

# Register a pane-focus-in hook that clears the marker when the pane is viewed.
#   $1 = pane  $2 = wrapper script path  $3 = the wrapper's unmark subcommand
nc_register_focus_hook() {
  local pane="$1" script="$2" unmark_cmd="$3"
  [ -z "$pane" ] && return
  tmux set-hook -w -t "$pane" pane-focus-in \
    "run-shell '\"$script\" $unmark_cmd \"$pane\"'"
}

# Mark the window and send a Ghostty notification if the user isn't looking.
#   $1 = pane  $2 = message  $3 = agent label (e.g. "Claude Code")
nc_notify() {
  local pane="$1" message="$2" label="$3"
  [ -z "$pane" ] && return

  local agent_session client_session window_active frontmost
  agent_session=$(tmux display-message -t "$pane" -p '#{session_name}')
  client_session=$(tmux list-clients -F '#{client_session}' | head -1)
  window_active=$(tmux display-message -t "$pane" -p '#{window_active}')
  frontmost=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

  # User is looking at the agent pane — nothing to do
  if [ "$frontmost" = "ghostty" ] && [ "$agent_session" = "$client_session" ] && [ "$window_active" = "1" ]; then
    return
  fi

  local title_format source_title
  title_format=$(tmux show-options -gv set-titles-string)
  source_title=$(tmux display-message -t "$pane" -p "$title_format")

  # Mark window with "!" when viewing a different window or session
  if [ "$agent_session" != "$client_session" ] || [ "$window_active" = "0" ]; then
    local current
    current=$(tmux display-message -t "$pane" -p '#W')
    case "$current" in
      *!) ;;
      *) tmux rename-window -t "$pane" "${current}!" ;;
    esac
  fi

  # Send Ghostty notification when app is not focused or viewing a different session
  if [ "$frontmost" != "ghostty" ] || [ "$agent_session" != "$client_session" ]; then
    local client_tty active_title
    client_tty=$(tmux list-clients -F '#{client_tty}' | head -1)
    [ -z "$client_tty" ] && return
    active_title=$(tmux display-message -t "${client_session}:" -p "$title_format")

    printf '\033]2;%s\007' "$label" > "$client_tty"
    sleep 0.2
    printf '\033]777;notify;%s;%s\007' "$source_title" "$message" > "$client_tty"
    printf '\033]2;%s\007' "$active_title" > "$client_tty"
  fi
}
