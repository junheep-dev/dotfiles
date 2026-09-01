local M = {}

local statuses = {}
local configured = false
local status_dir = vim.env.AGENT_STATUS_DIR or ("/tmp/agent-status-" .. vim.uv.getuid())
local source_by_tool = {
  claude = "claude",
  claude_continue = "claude",
  codex = "codex",
  codex_resume = "codex",
}

local function read(path)
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end
  local ok, value = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
  return ok and value or nil
end

local function belongs_here(state)
  return state.nvim ~= nil and state.nvim ~= "" and state.nvim == vim.v.servername
end

local function sidekick_states()
  local ok, result = pcall(function()
    return require("sidekick.cli.state").get({ attached = true })
  end)
  return ok and result or {}
end

local function sidekick_sessions()
  local sessions = {}
  local totals = {}
  for _, sidekick in ipairs(sidekick_states()) do
    local source = source_by_tool[sidekick.tool.name]
    if source and sidekick.session then
      sessions[#sessions + 1] = { source = source, sidekick = sidekick }
      totals[source] = (totals[source] or 0) + 1
    end
  end
  table.sort(sessions, function(a, b)
    if a.source ~= b.source then
      return a.source < b.source
    end
    return tostring(a.sidekick.session.id) < tostring(b.sidekick.session.id)
  end)
  return sessions, totals
end

local function acknowledge(path)
  local command = vim.fn.expand("~/.local/bin/agent-status")
  if vim.fn.executable(command) ~= 1 then
    return
  end
  vim.fn.jobstart({ command, "acknowledge-path", path }, { detach = true })
end

local function agent_status_for_sidekick(sidekick, source_count)
  local candidates = {}
  for path, status in pairs(statuses) do
    if status.source == source_by_tool[sidekick.tool.name] then
      candidates[#candidates + 1] = { path = path, status = status }
      local ancestors = {}
      for _, pid in ipairs(status.ancestor_pids or {}) do
        ancestors[pid] = true
      end
      for _, pid in ipairs(sidekick.session.pids or {}) do
        if ancestors[pid] then
          return path, status
        end
      end
    end
  end

  if source_count == 1 and #candidates == 1 then
    return candidates[1].path, candidates[1].status
  end
end

local function acknowledge_focused_terminal()
  local sessions, totals = sidekick_sessions()
  for _, item in ipairs(sessions) do
    local terminal = item.sidekick.terminal
    if terminal and terminal:is_focused() then
      local path = agent_status_for_sidekick(item.sidekick, totals[item.source])
      if path then
        acknowledge(path)
      end
      return
    end
  end
end

function M.update(path)
  local state = read(path)
  if state and belongs_here(state) then
    statuses[path] = state
  else
    statuses[path] = nil
  end
  vim.cmd.redrawstatus()
  return ""
end

function M.segments()
  local sessions, totals = sidekick_sessions()
  local indexes = {}
  local segments = {}
  for _, item in ipairs(sessions) do
    indexes[item.source] = (indexes[item.source] or 0) + 1
    local label = item.source
    if totals[item.source] > 1 then
      label = label .. " " .. indexes[item.source]
    end

    local terminal = item.sidekick.terminal
    if not (terminal and terminal:is_open()) then
      local _, agent_status = agent_status_for_sidekick(item.sidekick, totals[item.source])
      local status = "idle"
      local symbol = ""
      if agent_status and agent_status.phase == "running" then
        status = "activity"
        symbol = "●"
      elseif agent_status and agent_status.phase == "waiting" then
        status = "attention"
        symbol = "?"
      elseif agent_status and agent_status.phase == "done" and agent_status.unread then
        status = "attention"
        symbol = "!"
      end
      segments[#segments + 1] = {
        status = status,
        text = label .. (symbol == "" and "" or " " .. symbol),
      }
    end
  end
  return segments
end

function M.setup()
  if configured then
    return
  end
  configured = true

  for _, path in ipairs(vim.fn.globpath(status_dir, "*.json", false, true)) do
    M.update(path)
  end

  local group = vim.api.nvim_create_augroup("junheep_agent_status", { clear = true })
  vim.api.nvim_create_autocmd({ "WinEnter", "TermEnter" }, {
    group = group,
    callback = acknowledge_focused_terminal,
  })
end

return M
