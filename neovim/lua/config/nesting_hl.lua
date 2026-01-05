local M = {}

-- Experimental "nesting-level-only" highlighting scaffold.
-- This is intentionally simple: it highlights indentation blocks by depth.
--
-- It does NOT try to be a full semantic highlighter yet; it's a stepping stone.

local ns = vim.api.nvim_create_namespace("nesting_level_hl")
local enabled = false

local function define_default_colors()
  -- If you later build your own engine, you can replace these.
  -- These are subtle by design (work with many colorschemes).
  local groups = {
    { "NestingLevel1", { fg = "#7aa2f7" } },
    { "NestingLevel2", { fg = "#bb9af7" } },
    { "NestingLevel3", { fg = "#7dcfff" } },
    { "NestingLevel4", { fg = "#9ece6a" } },
    { "NestingLevel5", { fg = "#e0af68" } },
    { "NestingLevel6", { fg = "#f7768e" } },
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g[1], g[2])
  end
end

local function level_group(level)
  local idx = ((level - 1) % 6) + 1
  return "NestingLevel" .. tostring(idx)
end

local function clear(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function compute_indent_level(line)
  local indent = line:match("^[\t ]*") or ""
  -- Treat a tab as 4 spaces by default (match your settings)
  local spaces = 0
  for i = 1, #indent do
    local c = indent:sub(i, i)
    if c == "\t" then
      spaces = spaces + 4
    else
      spaces = spaces + 1
    end
  end
  return math.floor(spaces / 4)
end

local function apply(bufnr)
  if not enabled then
    return
  end
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  if vim.bo[bufnr].buftype ~= "" then
    return
  end

  clear(bufnr)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    if line ~= "" then
      local lvl = compute_indent_level(line)
      if lvl > 0 then
        -- Highlight the entire line based on indent depth.
        vim.api.nvim_buf_add_highlight(bufnr, ns, level_group(lvl), i - 1, 0, -1)
      end
    end
  end
end

function M.enable()
  enabled = true
  define_default_colors()
  apply(0)
end

function M.disable()
  enabled = false
  clear(0)
end

function M.toggle()
  if enabled then
    M.disable()
    vim.notify("Nesting highlight: OFF", vim.log.levels.INFO)
  else
    M.enable()
    vim.notify("Nesting highlight: ON", vim.log.levels.INFO)
  end
end

function M.setup_autocmd()
  local group = vim.api.nvim_create_augroup("nesting_hl_refresh", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "BufWritePost" }, {
    group = group,
    callback = function(args)
      apply(args.buf)
    end,
  })
end

return M


