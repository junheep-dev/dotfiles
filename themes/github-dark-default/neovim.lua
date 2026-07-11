-- Active theme + its own config, consumed by the theme manager
-- (nvim/lua/plugins/colorscheme.lua). Lives under plugins/ so lazy's
-- change_detection watches it; theme.sh swaps this file in.
-- The spec fragment merges onto the bare install in colorscheme.lua.
vim.g.active_colorscheme = "github_dark_default"
return {
  {
    "projekt0n/github-nvim-theme",
    config = function()
      require("github-theme").setup({})
    end,
  },
}
