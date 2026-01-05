local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yank
autocmd("TextYankPost", {
  group = augroup("yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Optional HTML void-element normalization: <img /> -> <img>
-- You can toggle this off by setting vim.g.html_void_no_slash = false in init.lua
vim.g.html_void_no_slash = false

local function normalize_html_void_elements(bufnr)
  if not vim.g.html_void_no_slash then
    return
  end
  local ft = vim.bo[bufnr].filetype
  if ft ~= "html" then
    return
  end

  -- Skip XHTML or XML-ish buffers by heuristics
  local first = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(20, vim.api.nvim_buf_line_count(bufnr)), false)
  for _, line in ipairs(first) do
    if line:match("<!DOCTYPE%s+html") then
      goto continue
    end
    if line:match("<%?xml") or line:match("<!DOCTYPE%s+html[^>]*xhtml") then
      return
    end
    ::continue::
  end

  -- Replace `/>` on HTML5 void elements
  -- Note: intentionally conservative: only matches `<tag ... />` (space before slash).
  local void_tags = { "img", "br", "hr", "meta", "link", "input", "source", "area", "base", "col", "embed", "param", "track", "wbr" }
  local tags_pat = table.concat(void_tags, "|")
  local pattern = "<(" .. tags_pat .. ")([^>]*)%s*/>"
  local replacement = "<%1%2>"

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local changed = false
  for i, l in ipairs(lines) do
    local nl, n = l:gsub(pattern, replacement)
    if n > 0 then
      lines[i] = nl
      changed = true
    end
  end
  if changed then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end
end

autocmd("BufWritePre", {
  group = augroup("html_void_fix", { clear = true }),
  callback = function(args)
    normalize_html_void_elements(args.buf)
  end,
})

-- Nesting-only highlight scaffold (off by default)
-- Toggle with :NestingHLToggle
vim.api.nvim_create_user_command("NestingHLToggle", function()
  local nh = require("config.nesting_hl")
  nh.setup_autocmd()
  nh.toggle()
end, {})

-- Keep absolute line numbers enabled in normal file buffers.
-- (Some plugin windows intentionally disable numbers; we leave those alone.)
autocmd({ "BufEnter", "WinEnter" }, {
  group = augroup("force_absolute_numbers", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    vim.wo.number = true
  end,
})

