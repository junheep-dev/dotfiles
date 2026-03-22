# Neovim Custom Config Migration

LazyVim → custom lazy.nvim 마이그레이션. 플러그인을 하나씩 추가하며 검증.

## Directory Layout

- `nvim/` — 기존 LazyVim config (건드리지 않음)
- `nvim-temp/` — 전체 마이그레이션 레퍼런스 (`nvim-custom-config-full` 브랜치에서 추출)
- `nvim-custom/` — 점진적 재구축 (현재 작업 중)

## Test Command

```bash
XDG_CONFIG_HOME=/Users/jerome/workspace/dotfiles NVIM_APPNAME=nvim-custom nvim
```

## Completed

- `config/options.lua` — leader keys, spelllang
- `config/lazy.lua` — lazy.nvim bootstrap, loads options before lazy
- `plugins/treesitter.lua` — nvim-treesitter (master branch, auto_install, highlight, indent)
- `plugins/lsp.lua` — lspconfig + mason + mason-lspconfig, LspAttach keymaps (fzf-lua for gd/gr/gI/gy), lua_ls only
- `plugins/completion.lua` — blink.cmp with friendly-snippets, default keymap preset
- `plugins/fzf.lua` — fzf-lua with basic keymaps (files, buffers, grep, help, keymaps, resume)

## Remaining (priority order)

1. File explorer (neo-tree)
2. UI (lualine, bufferline, noice, scrollbar)
3. Git (gitsigns, gitlinker, diffview)
4. AI (copilot, sidekick)
5. Coding (mini.surround, mini.pairs, flash, yanky)
6. Formatting (conform.nvim, prettier)
7. Linting (nvim-lint, eslint)
8. Colorschemes (last)

## Decisions

- No `ensure_installed` for treesitter — `auto_install = true` is sufficient
- No `automatic_enable` in mason-lspconfig — manage servers explicitly in `servers` table for visibility
- LSP keymaps (gd, gr, gI, gy) use fzf-lua for better UX with multiple results
- mason-lspconfig may be removable if not using any of its features
- Neovim 0.11.5: using new `vim.lsp.config()` / `vim.lsp.enable()` API
- nvim-treesitter uses `master` branch (`main` requires Neovim 0.12 nightly)
