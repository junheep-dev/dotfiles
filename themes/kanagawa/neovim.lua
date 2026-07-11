-- Active theme + its own config, consumed by the theme manager
-- (nvim/lua/plugins/colorscheme.lua). Lives under plugins/ so lazy's
-- change_detection watches it; theme.sh swaps this file in.
-- The spec fragment merges onto the bare install in colorscheme.lua.
vim.g.active_colorscheme = "kanagawa"
return {
  { "rebelot/kanagawa.nvim", opts = { background = { dark = "dragon" } } },
}
