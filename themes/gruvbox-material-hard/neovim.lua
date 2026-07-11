-- Active theme + its own config, consumed by the theme manager
-- (nvim/lua/plugins/colorscheme.lua). Lives under plugins/ so lazy's
-- change_detection watches it; theme.sh swaps this file in.
-- Same plugin/colorscheme as gruvbox-material, but with the hard (darkest)
-- background. g: vars are set here so they apply before the colorscheme.
vim.g.active_colorscheme = "gruvbox-material"
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_enable_italic = true
return {}
