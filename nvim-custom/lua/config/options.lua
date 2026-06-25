-- Loaded before lazy.nvim startup (see config.lazy).

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- fix markdown indentation settings (read by Neovim's builtin markdown ftplugin)
vim.g.markdown_recommended_style = 0

local opt = vim.opt

-- General behavior
opt.mouse = "a" -- enable mouse mode
opt.autowrite = true -- enable auto write
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.updatetime = 200 -- save swap file and trigger CursorHold
opt.timeoutlen = 300 -- lower than default (1000) to quickly trigger which-key
opt.jumpoptions = "view" -- restore the window view when jumping back

-- UI & appearance
opt.number = true -- print line number
opt.relativenumber = true -- relative line numbers
opt.cursorline = true -- enable highlighting of the current line
opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
opt.termguicolors = true -- true color support
opt.laststatus = 3 -- global statusline
opt.showmode = true -- show mode in the command line
opt.ruler = true -- show the default ruler
opt.scrolloff = 4 -- keep 4 lines visible above/below the cursor
opt.sidescrolloff = 8 -- keep 8 columns visible left/right of the cursor
opt.smoothscroll = true -- scroll one screen line at a time on wrapped lines
opt.list = true -- show some invisible characters (tabs...)
opt.fillchars = {
	foldopen = "\u{f47c}",
	foldclose = "\u{f460}",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
-- opt.statuscolumn -- TODO: set via snacks.nvim statuscolumn once snacks is added

-- Indentation
opt.expandtab = true -- use spaces instead of tabs
opt.shiftwidth = 2 -- size of an indent
opt.tabstop = 2 -- number of spaces tabs count for
opt.shiftround = true -- round indent
opt.smartindent = true -- insert indents automatically

-- Line wrapping
opt.wrap = false -- disable line wrap
opt.linebreak = true -- wrap lines at convenient points (when wrap is on)

-- Folding
opt.foldlevel = 99
opt.foldmethod = "indent" -- TODO: switch to treesitter foldexpr once the treesitter plugin is added
opt.foldtext = ""

-- Search
opt.ignorecase = true -- ignore case
opt.smartcase = true -- don't ignore case with capitals
opt.inccommand = "nosplit" -- preview incremental substitute
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Completion & command-line
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10 -- maximum number of entries in a popup
opt.pumblend = 10 -- popup blend
opt.wildmode = "longest:full,full" -- command-line completion mode

-- Windows & splits
opt.splitbelow = true -- put new windows below current
opt.splitright = true -- put new windows right of current
opt.splitkeep = "screen"
opt.winminwidth = 5 -- minimum window width

-- Files & session
-- only set clipboard if not in ssh, to make sure the OSC 52 integration works automatically
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- sync with system clipboard
opt.undofile = true
opt.undolevels = 10000
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Formatting
opt.formatoptions = "jcroqlnt" -- tcqj
-- opt.formatexpr -- TODO: point at conform's formatexpr once conform.nvim is added

-- Misc
opt.spelllang = { "en", "cjk" } -- en + cjk so CJK text isn't flagged as misspelled
