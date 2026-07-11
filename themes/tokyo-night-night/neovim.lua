-- Active theme + its own config, consumed by the theme manager
-- (nvim/lua/plugins/colorscheme.lua). Lives under plugins/ so lazy's
-- change_detection watches it; theme.sh swaps this file in.
-- The spec fragment merges onto the bare install in colorscheme.lua.
vim.g.active_colorscheme = "tokyonight-night"
return {
  { "folke/tokyonight.nvim", opts = { style = "night" } },
}
