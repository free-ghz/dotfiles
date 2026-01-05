-- Buffer-local settings for DreamWiki (*.dream / *.dreamwiki)

vim.bo.commentstring = "^%s"

-- You asked for rulers:
-- - strongest at 40
-- - medium at 20 and 30
-- - weak at every 4 up to 40
require("config.dreamwiki").enable_column_guides(0)
vim.b.dreamwiki_guides_on = true

vim.api.nvim_buf_create_user_command(0, "DreamWikiGuidesToggle", function()
  local dw = require("config.dreamwiki")
  if vim.b.dreamwiki_guides_on then
    vim.b.dreamwiki_guides_on = false
    dw.disable_column_guides(0)
  else
    vim.b.dreamwiki_guides_on = true
    dw.enable_column_guides(0)
  end
end, {})


