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
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        win = {
          split = { width = 0.4 },
        },
        tools = {
          claude_continue = { cmd = { "claude", "--continue" } },
        },
      },
    },
    keys = {
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "n", "x" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Select Prompt",
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Toggle Claude",
      },
      {
        "<leader>aC",
        function()
          require("sidekick.cli").toggle({ name = "claude_continue", focus = true })
        end,
        desc = "Toggle Claude Continue",
      },
    },
  },
}
