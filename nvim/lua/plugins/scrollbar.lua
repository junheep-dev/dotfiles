-- Scrollbar with diagnostic/search/cursor marks. This config tracks git changes
-- with mini.diff, not gitsigns, so the plugin's built-in git handler (gitsigns
-- only) stays off; instead we feed mini.diff hunks in, reusing the plugin's own
-- GitAdd/GitChange/GitDelete mark styles.
return {
  "petertriho/nvim-scrollbar",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("scrollbar").setup()

    local utils = require("scrollbar.utils")
    local render = require("scrollbar").throttled_render
    -- mini.diff hunk type -> scrollbar mark type (same names the gitsigns
    -- handler uses, so the configured mark glyphs/highlights are reused).
    local type_map = { add = "GitAdd", change = "GitChange", delete = "GitDelete" }
    -- Each mark carries its own glyph text. The Git* marks use a plain string
    -- ("┆"/"▁"), so we must pass it explicitly (unlike diagnostic marks whose
    -- text is a list the plugin can index into).
    local mark_text = require("scrollbar.config").get().marks

    -- Store this buffer's mini.diff marks under our own namespace, mirroring the
    -- built-in gitsigns handler: compute marks only when the diff changes (see
    -- the MiniDiffUpdated autocmd below), not on every scrollbar render. This is
    -- both cheaper than a registered handler (which re-runs on every render
    -- event) and correct while typing (render events skip insert-mode changes).
    local function set_marks(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      local marks = {}
      local ok, data = pcall(require("mini.diff").get_buf_data, bufnr)
      if ok and type(data) == "table" and data.hunks then
        for _, hunk in ipairs(data.hunks) do
          if hunk.type == "delete" then
            -- Deletes have no buffer lines (buf_count == 0); collapse to a single
            -- mark at the hunk's buffer anchor. buf_start is 0 when lines are
            -- deleted before the first line, so clamp to line 1.
            marks[#marks + 1] =
              { line = math.max(hunk.buf_start, 1) - 1, type = "GitDelete", text = mark_text.GitDelete.text }
          else
            local mtype = type_map[hunk.type]
            for line = hunk.buf_start, hunk.buf_start + hunk.buf_count - 1 do
              marks[#marks + 1] = { line = line - 1, type = mtype, text = mark_text[mtype].text }
            end
          end
        end
      end
      local scrollbar_marks = utils.get_scrollbar_marks(bufnr)
      scrollbar_marks.mini_diff = marks -- replace (empties clear stale marks)
      utils.set_scrollbar_marks(bufnr, scrollbar_marks)
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniDiffUpdated",
      group = vim.api.nvim_create_augroup("junheep_scrollbar_minidiff", { clear = true }),
      callback = function(args)
        set_marks(args.buf)
        render()
      end,
    })
  end,
}
