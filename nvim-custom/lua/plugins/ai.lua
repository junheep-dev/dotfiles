vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("junheep_copilot", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "copilot" then
      return
    end

    vim.lsp.inline_completion.enable(true, { bufnr = args.buf })

    vim.keymap.set({ "i", "n" }, "<M-]>", function()
      vim.lsp.inline_completion.select({ count = 1 })
    end, { buffer = args.buf, desc = "Next Copilot Suggestion" })
    vim.keymap.set({ "i", "n" }, "<M-[>", function()
      vim.lsp.inline_completion.select({ count = -1 })
    end, { buffer = args.buf, desc = "Prev Copilot Suggestion" })
    vim.keymap.set("i", "<Tab>", function()
      if not vim.lsp.inline_completion.get() then
        return "<Tab>"
      end
    end, { buffer = args.buf, expr = true, remap = true, desc = "Accept Copilot Suggestion" })
  end,
})

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "copilot-language-server" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { copilot = {} } },
  },
}
