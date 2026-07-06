return {
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = {
        preset = "default",
      },
      signature = {
        -- Disable after try this feature
        enabled = true,
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      cmdline = {
        enabled = false,
      },
    },
  },
}
