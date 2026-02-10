#!/bin/bash
# Claude Code notification hook for tmux + Ghostty
#
# Actions:
#   setup  - Register pane-focus-in hook to clear "!" marker
#   add    - Mark window with "!" and send Ghostty notification
#   remove - Clear "!" marker from window name

[ -z "$TMUX" ] && exit 0

case "$1" in
  remove) pane="$2" ;;
  *) pane="$TMUX_PANE" ;;
esac
[ -z "$pane" ] && exit 0

notify() {
  local claude_session client_session window_active frontmost

  claude_session=$(tmux display-message -t "$pane" -p '#{session_name}')
  client_session=$(tmux list-clients -F '#{client_session}' | head -1)
  window_active=$(tmux display-message -t "$pane" -p '#{window_active}')
  frontmost=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

  # User is looking at the Claude pane — nothing to do
  if [ "$frontmost" = "ghostty" ] && [ "$claude_session" = "$client_session" ] && [ "$window_active" = "1" ]; then
    return
  fi

  local claude_title
  claude_title=$(tmux display-message -t "$pane" -p '#S - #I #W')

  # Mark window with "!" when viewing a different window or session
  if [ "$claude_session" != "$client_session" ] || [ "$window_active" = "0" ]; then
    local current
    current=$(tmux display-message -t "$pane" -p '#W')
    case "$current" in
      *!) ;;
      *) tmux rename-window -t "$pane" "${current}!" ;;
    esac
  fi

  # Send Ghostty notification when app is not focused or viewing a different session
  if [ "$frontmost" != "ghostty" ] || [ "$claude_session" != "$client_session" ]; then
    local client_tty message active_title
    client_tty=$(tmux list-clients -F '#{client_tty}' | head -1)
    [ -z "$client_tty" ] && return

    message=$(cat /dev/stdin 2>/dev/null | jq -r '.message // empty')
    active_title=$(tmux display-message -t "${client_session}:" -p '#S - #I #W')

    printf '\033]2;%s\007' "Claude Code" > "$client_tty"
    sleep 0.2
    printf '\033]777;notify;%s;%s\007' "$claude_title" "$message" > "$client_tty"
    printf '\033]2;%s\007' "$active_title" > "$client_tty"
  fi
}

case "$1" in
  add)
    notify
    ;;
  remove)
    current=$(tmux display-message -t "$pane" -p '#W')
    tmux rename-window -t "$pane" "${current%!}"
    ;;
  setup)
    tmux set-hook -w -t "$pane" pane-focus-in "run-shell '\"$0\" remove \"$pane\"'"
    ;;
esac
