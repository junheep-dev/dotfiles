#!/bin/zsh

print_header "Typora"

TYPORA_THEMES_DIR="$HOME/Library/Application Support/abnerworks.Typora/themes"

# Check if Typora is installed
if [ ! -d "$TYPORA_THEMES_DIR" ]; then
  print_error "Typora is not installed or has never been launched. Please install and run Typora first."
  exit 1
fi

print_step "Setup Typora themes"

# Symlink CSS files
print_step "Symlink Typora theme files"

# Symlink ia-writer.css
if [ -L "$TYPORA_THEMES_DIR/ia-writer.css" ]; then
  rm "$TYPORA_THEMES_DIR/ia-writer.css"
elif [ -f "$TYPORA_THEMES_DIR/ia-writer.css" ]; then
  mv "$TYPORA_THEMES_DIR/ia-writer.css" "$TYPORA_THEMES_DIR/ia-writer.css.backup"
fi
ln -s "$DOTFILES_DIR/typora/ia-writer.css" "$TYPORA_THEMES_DIR/ia-writer.css"
print_success "Symlinked ia-writer.css"

# Symlink ia-writer-night.css
if [ -L "$TYPORA_THEMES_DIR/ia-writer-night.css" ]; then
  rm "$TYPORA_THEMES_DIR/ia-writer-night.css"
elif [ -f "$TYPORA_THEMES_DIR/ia-writer-night.css" ]; then
  mv "$TYPORA_THEMES_DIR/ia-writer-night.css" "$TYPORA_THEMES_DIR/ia-writer-night.css.backup"
fi
ln -s "$DOTFILES_DIR/typora/ia-writer-night.css" "$TYPORA_THEMES_DIR/ia-writer-night.css"
print_success "Symlinked ia-writer-night.css"

# Symlink fonts directory
print_step "Symlink font directory"

IA_WRITER_DIR="$TYPORA_THEMES_DIR/ia-writer"
if [ -L "$IA_WRITER_DIR" ]; then
  rm "$IA_WRITER_DIR"
elif [ -d "$IA_WRITER_DIR" ]; then
  mv "$IA_WRITER_DIR" "$IA_WRITER_DIR.backup"
fi
ln -s "$DOTFILES_DIR/typora/ia-writer" "$IA_WRITER_DIR"
print_success "Symlinked ia-writer directory"

print_success "Typora setup complete"
