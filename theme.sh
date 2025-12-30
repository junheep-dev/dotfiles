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

THEME_NAMES=("Tokyo Night" "Tokyo Night night" "Catppuccin" "Gruvbox Material" "GitHub Dark Default" "Kanagawa")
THEME=$(gum choose "${THEME_NAMES[@]}" "<< Quit" --header "Choose your theme" --height 10 | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

if [ -n "$THEME" ] && [ "$THEME" != "<<-quit" ]; then
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  git update-index --skip-worktree tmux/.tmux.theme.conf
  git update-index --skip-worktree ghostty/theme

  cp "$DOTFILES_DIR/themes/$THEME/.tmux.conf" ~/.tmux/.tmux.theme.conf
  cp "$DOTFILES_DIR/themes/$THEME/neovim.lua" ~/.config/nvim/lua/plugins/theme.lua
  cp "$DOTFILES_DIR/themes/$THEME/ghostty" ~/.config/ghostty/theme

  tmux source ~/.tmux.conf

  if pgrep -x ghostty >/dev/null; then
    killall -SIGUSR1 ghostty
    open -a Ghostty
  fi
fi
