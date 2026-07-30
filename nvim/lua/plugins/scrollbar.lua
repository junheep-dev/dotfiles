-- Scrollbar with diagnostic/search/cursor marks; git marks come from the
-- plugin's built-in gitsigns handler.
return {
  "petertriho/nvim-scrollbar",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("scrollbar").setup()
    require("scrollbar.handlers.gitsigns").setup()
  end,
}
