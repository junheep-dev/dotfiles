-- Active theme, consumed by the theme manager
-- (nvim/lua/plugins/colorscheme.lua). Lives under plugins/ so lazy's
-- change_detection watches it; theme.sh swaps this file in.
-- Catppuccin defaults (mocha), except `term_colors`: it is off by default, and
-- without it the ANSI palette the manager reads for diff colors is whatever the
-- previously active theme left behind.
vim.g.active_colorscheme = "catppuccin"
return {
  -- `name` must match the base spec in colorscheme.lua, or lazy treats this as
  -- a second plugin ("nvim") instead of merging onto the installed one
  { "catppuccin/nvim", name = "catppuccin", opts = { term_colors = true } },
}
