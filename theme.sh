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

THEME_NAMES=("Tokyo Night Moon" "Tokyo Night Night" "Catppuccin Mocha" "Gruvbox Material" "Gruvbox Material Hard" "GitHub Dark Default" "Kanagawa Dragon")
THEME_DISPLAY=$(gum choose "${THEME_NAMES[@]}" "<< Quit" --header "Choose your theme" --height 10)
THEME=$(echo "$THEME_DISPLAY" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

if [ -n "$THEME" ] && [ "$THEME" != "<<-quit" ]; then
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  git update-index --skip-worktree tmux/tmux.theme.conf
  git update-index --skip-worktree ghostty/theme
  git update-index --skip-worktree btop/themes/current.theme

  cp "$DOTFILES_DIR/themes/$THEME/tmux.conf" ~/.tmux/tmux.theme.conf
  cp "$DOTFILES_DIR/themes/$THEME/neovim.lua" ~/.config/nvim/lua/plugins/theme.lua
  cp "$DOTFILES_DIR/themes/$THEME/ghostty" ~/.config/ghostty/theme
  cp "$DOTFILES_DIR/themes/$THEME/btop.theme" ~/.config/btop/themes/current.theme

  # Desktop wallpaper: warm themes -> Golden Gate day, cool/dark themes ->
  # Golden Gate night, anything else -> NYC (fallback).
  WP_DIR="$DOTFILES_DIR/wallpapers"
  GG_DAY="$WP_DIR/golden-gate-day.jpg"
  GG_NIGHT="$WP_DIR/golden-gate-night.jpg"
  case "$THEME" in
  gruvbox-material | gruvbox-material-hard | kanagawa-dragon)
    WALLPAPER="$GG_DAY"
    ;;
  tokyo-night-moon | tokyo-night-night | catppuccin-mocha | github-dark-default)
    WALLPAPER="$GG_NIGHT"
    ;;
  *)
    WALLPAPER="$WP_DIR/nyc-manhattan-dusk.jpg"
    ;;
  esac
  if [ -f "$WALLPAPER" ]; then
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"$WALLPAPER\""
  fi

  tmux source ~/.tmux.conf
  pkill -SIGUSR2 ghostty
  echo "Theme changed to $THEME_DISPLAY"
fi
