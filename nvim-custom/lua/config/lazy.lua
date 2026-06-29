-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- load options before lazy so they apply correctly while installing plugins
require("config.options")

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.lang" },
  },
  defaults = {
    -- custom plugins load on startup; set to true to lazy-load them by default
    lazy = false,
    -- always use the latest git commit; many plugins ship outdated releases
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- periodically check for plugin updates
    notify = false, -- but don't notify
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- load autocmds early when starting without a file, otherwise defer to VeryLazy
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
  require("config.autocmds")
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("junheep_lazy", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    if lazy_autocmds then
      require("config.autocmds")
    end
    require("config.keymaps")
  end,
})
