local M = {}

-- Multi-strength "rulers" (vertical column guides) for DreamWiki buffers.
-- We can't use :set colorcolumn for multiple intensities because it only uses one highlight group.
-- So we draw overlay glyphs at specific window columns via extmarks.

local ns = vim.api.nvim_create_namespace("dreamwiki_column_guides")
local enabled_buf = {}
local cached_specs = nil

local function set_default_hl()
  -- Subtle defaults that should work across colorschemes.
  -- You can override these in your colorscheme or init.lua later.
  vim.api.nvim_set_hl(0, "DreamWikiGuideWeak", { fg = "#3b4261" })
  vim.api.nvim_set_hl(0, "DreamWikiGuideMed", { fg = "#565f89" })
  vim.api.nvim_set_hl(0, "DreamWikiGuideStrong", { fg = "#9aa5ce" })
end

local function guides_spec()
  -- 4,8,...,40 weak; 20 & 30 medium; 40 strong
  local cols = {}
  for c = 4, 40, 4 do
    cols[#cols + 1] = { col = c, hl = "DreamWikiGuideWeak" }
  end
  for _, c in ipairs({ 20, 30 }) do
    cols[#cols + 1] = { col = c, hl = "DreamWikiGuideMed" }
  end
  cols[#cols + 1] = { col = 40, hl = "DreamWikiGuideStrong" }
  return cols
end

local function clear(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

-- One global decoration provider; it draws for any enabled DreamWiki buffer.
local provider_set = false
local function ensure_provider()
  if provider_set then
    return
  end
  provider_set = true
  vim.api.nvim_set_decoration_provider(ns, {
    on_line = function(_, winid, bufnr, row)
      if not enabled_buf[bufnr] then
        return
      end
      if vim.bo[bufnr].filetype ~= "dreamwiki" then
        return
      end
      if not vim.api.nvim_win_is_valid(winid) then
        return
      end
      if vim.api.nvim_win_get_buf(winid) ~= bufnr then
        return
      end

      local specs = cached_specs or guides_spec()
      cached_specs = specs
      local char = "│"

      for _, s in ipairs(specs) do
        vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
          virt_text = { { char, s.hl } },
          virt_text_pos = "overlay",
          virt_text_win_col = s.col - 1, -- 0-based window column
          hl_mode = "combine",
          priority = 50,
          ephemeral = true, -- critical: don't persist/clear marks during redraw
        })
      end
    end,
  })
end

function M.enable_column_guides(bufnr)
  bufnr = bufnr or 0
  set_default_hl()
  ensure_provider()
  enabled_buf[bufnr] = true

  -- Force a redraw.
  vim.cmd("redraw")
end

function M.disable_column_guides(bufnr)
  bufnr = bufnr or 0
  enabled_buf[bufnr] = nil
  clear(bufnr)
  vim.cmd("redraw")
end

return M


