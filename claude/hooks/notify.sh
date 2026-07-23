#!/bin/bash
# Claude Code notification hook for tmux + Ghostty
#
# Actions:
#   setup  - Register pane-focus-in hook to clear "!" marker
#   add    - Mark window with "!" and send Ghostty notification
#   remove - Clear "!" marker from window name

[ -z "$TMUX" ] && exit 0
source "$(dirname "$0")/notify-core.sh"

case "$1" in
  add)
    message=$(cat /dev/stdin 2>/dev/null | jq -r '.message // empty')
    nc_notify "$TMUX_PANE" "$message" "Claude Code"
    ;;
  remove)
    nc_unmark "$2"
    ;;
  setup)
    nc_register_focus_hook "$TMUX_PANE" "$0" "remove"
    ;;
esac
