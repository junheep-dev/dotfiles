local M = {}

-- Icons used across the config
M.icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = "󰆕 ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = "󱄽 ",
    String = " ",
    Struct = "󰆼 ",
    Supermaven = " ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
  },
}

--- Get project root directory
---@param buf? number
---@return string
function M.root(buf)
  local path = vim.fs.root(buf or 0, { ".git", "package.json", "Makefile", "Gemfile", "go.mod", "Cargo.toml" })
  return path or vim.uv.cwd()
end

--- Get git root directory
---@param buf? number
---@return string
function M.git_root(buf)
  local path = vim.fs.root(buf or 0, { ".git" })
  return path or vim.uv.cwd()
end

--- Check if a plugin is available in lazy.nvim spec
---@param name string
---@return boolean
function M.has(name)
  local ok, config = pcall(require, "lazy.core.config")
  return ok and config.spec.plugins[name] ~= nil
end

--- Check if a plugin is loaded
---@param name string
---@return boolean
function M.is_loaded(name)
  local ok, config = pcall(require, "lazy.core.config")
  return ok and config.plugins[name] ~= nil and config.plugins[name]._.loaded ~= nil
end

--- Execute callback when a plugin loads
---@param name string
---@param fn fun()
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn()
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn()
          return true -- delete autocmd
        end
      end,
    })
  end
end

--- Schedule callback on VeryLazy event
---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

--- Get resolved opts for a plugin
---@param name string
---@return table
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  return require("lazy.core.plugin").values(plugin, "opts", false)
end

--- Get mason package path
---@param pkg string
---@param path string
---@return string
function M.get_pkg_path(pkg, path)
  pcall(require, "mason")
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  return root .. "/packages/" .. pkg .. "/" .. (path or "")
end

--- Count normal windows (excludes floating windows and neo-tree)
---@return number
function M.get_normal_win_count()
  local normal_wins = vim.tbl_filter(function(win)
    local config = vim.api.nvim_win_get_config(win)
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
    return config.relative == "" and filetype ~= "neo-tree"
  end, vim.api.nvim_tabpage_list_wins(0))
  return #normal_wins
end

return M
