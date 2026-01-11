#!/bin/zsh

# Check if gum is installed
if ! command -v gum &>/dev/null; then
  echo "gum is not installed. Would you like to install it? (y/n)"
  read -r response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Installing gum via Homebrew..."
    brew install gum
  else
    echo "gum is required to run this script."
    exit 1
  fi
fi

FONT_NAMES=("Cascadia Code" "IBM Plex Mono")
FONT_DISPLAY=$(gum choose "${FONT_NAMES[@]}" "<< Quit" --header "Choose your font" --height 10)
FONT=$(echo "$FONT_DISPLAY" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

if [ -n "$FONT" ] && [ "$FONT" != "<<-quit" ]; then
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  git update-index --skip-worktree ghostty/font

  cp "$DOTFILES_DIR/fonts/$FONT" ~/.config/ghostty/font

  pkill -SIGUSR2 ghostty
  echo "Font changed to $FONT_DISPLAY"
fi
