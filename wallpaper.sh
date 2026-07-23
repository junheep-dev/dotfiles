#!/bin/zsh

# Choose and apply a desktop wallpaper.
# Optional $1 is a theme name, used only to preselect the recommended default:
# warm themes -> Golden Gate day, cool/dark themes -> Golden Gate night.

if ! command -v gum &>/dev/null; then
  echo "gum is required to run this script."
  exit 1
fi

DOTFILES_DIR="${0:A:h}"
WP_DIR="$DOTFILES_DIR/wallpapers"

case "$1" in
gruvbox-material | gruvbox-material-hard | kanagawa-dragon)
  WP_DEFAULT="Golden Gate (day)"
  ;;
tokyo-night-moon | tokyo-night-night | catppuccin-mocha | github-dark-default)
  WP_DEFAULT="Golden Gate (night)"
  ;;
*)
  WP_DEFAULT="NYC Manhattan Dusk"
  ;;
esac

WP_CHOICE=$(gum choose \
  "Golden Gate (day)" \
  "Golden Gate (night)" \
  "NYC Manhattan Dusk" \
  "Keep current wallpaper" \
  --header "Choose your wallpaper" --height 10 --selected "$WP_DEFAULT")

case "$WP_CHOICE" in
"Golden Gate (day)")
  WALLPAPER="$WP_DIR/golden-gate-day.jpg"
  ;;
"Golden Gate (night)")
  WALLPAPER="$WP_DIR/golden-gate-night.jpg"
  ;;
"NYC Manhattan Dusk")
  WALLPAPER="$WP_DIR/nyc-manhattan-dusk.jpg"
  ;;
*)
  WALLPAPER=""
  ;;
esac

if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
  osascript -e "tell application \"System Events\" to set picture of every desktop to \"$WALLPAPER\""
  echo "Wallpaper changed to $WP_CHOICE"
fi
