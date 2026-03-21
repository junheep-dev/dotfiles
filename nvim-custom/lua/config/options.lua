vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.spelllang = { "en", "cjk" }
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.ignorecase = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4
opt.signcolumn = "yes"
opt.undofile = true
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.showmode = false
opt.splitbelow = true
opt.splitright = true
opt.wrap = false
