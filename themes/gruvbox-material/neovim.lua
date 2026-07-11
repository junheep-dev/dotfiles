-- Active theme + its own config, consumed by the theme manager
-- (nvim/lua/plugins/colorscheme.lua). Lives under plugins/ so lazy's
-- change_detection watches it; theme.sh swaps this file in.
-- gruvbox-material reads g: vars, so set them here (runs on every import,
-- i.e. before the colorscheme is applied on startup and on live switch).
vim.g.active_colorscheme = "gruvbox-material"
vim.g.gruvbox_material_enable_italic = true
return {}
