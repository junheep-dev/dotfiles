# Dotfiles

## How to setup

1. Install [brew](https://brew.sh/)

2. Install git via brew

   ```bash
   brew install git
   ```

3. Clone this repository into `~/workspace/dotfiles`

   ```bash
   git clone https://github.com/junheep-dev/dotfiles.git ~/workspace/dotfiles
   ```

4. Run `./install.sh`

   ```bash
   cd ~/workspace/dotfiles
   ./install.sh
   ```

   For work environments, you can skip personal apps:

   ```bash
   ./install.sh --work
   ```

5. Restart mac

## Theme Switching

Switch between my favorite color themes for tmux, neovim, and ghostty:

```bash
./theme.sh
```

Available themes:

- Tokyo Night
- Tokyo Night night
- Catppuccin
- Gruvbox Material
- GitHub Dark Default
- Kanagawa

_Inspired by [Omakub's theme switcher](https://github.com/basecamp/omakub)_
