-- Active theme + its own config, consumed by the theme manager
-- (nvim/lua/plugins/colorscheme.lua). Lives under plugins/ so lazy's
-- change_detection watches it; theme.sh swaps this file in.
-- gruvbox-material with the "mix" foreground palette (the default). g: vars set
-- here so they apply before the colorscheme; both are explicit so switching
-- to/from the hard variant resets them.
vim.g.active_colorscheme = "gruvbox-material"
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_enable_italic = true
return {}
