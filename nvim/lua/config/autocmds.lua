-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- For hugo templates
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.html",
  callback = function()
    if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
      vim.bo.filetype = "gotmpl"
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false

    vim.keymap.set("v", "<leader>ml", 'c[<C-r>"]()<Esc>T(i', {
      desc = "Markdown link",
      buffer = true,
    })
  end,
})
