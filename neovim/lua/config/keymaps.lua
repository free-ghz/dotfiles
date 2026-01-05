local map = vim.keymap.set

-- Quick escape in terminal
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal: normal mode" })

-- Toggle relative numbers (keep absolute numbers always on)
map("n", "<leader>nr", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative numbers" })

-- Line endings helpers
map("n", "<leader>fu", function()
  vim.opt.fileformat = "unix"
  vim.notify("fileformat=unix", vim.log.levels.INFO)
end, { desc = "Set line endings: unix (LF)" })

map("n", "<leader>fd", function()
  vim.opt.fileformat = "dos"
  vim.notify("fileformat=dos", vim.log.levels.INFO)
end, { desc = "Set line endings: dos (CRLF)" })

-- Basic quality-of-life
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })

-- Lint (no plugin): runs ESLint for JS inside HTML <script> tags
map("n", "<leader>l", function()
  require("config.lint").lint_current()
end, { desc = "Lint current buffer" })

-- Local-server LLM
map({ "n", "v" }, "<leader>ai", function()
  require("config.llm").prompt()
end, { desc = "LLM: prompt (uses selection in visual mode)" })

-- Open files (fuzzy)
map("n", "<leader>ff", function()
  vim.cmd("Telescope find_files hidden=true")
end, { desc = "Find files" })

map("n", "<leader>fg", function()
  vim.cmd("Telescope live_grep")
end, { desc = "Live grep (requires rg)" })

-- Pick theme (shows installed colorschemes)
map("n", "<leader>tt", function()
  require("config.theme").pick()
end, { desc = "Themes: pick colorscheme" })

