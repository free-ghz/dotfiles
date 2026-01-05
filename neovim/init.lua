-- Portable Neovim config (Windows/macOS/Linux)
-- Put this folder at:
--  - macOS/Linux: ~/.config/nvim
--  - Windows:     %LOCALAPPDATA%\nvim

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Optional: hide these themes in the theme picker (<leader>tt)
-- (Useful to get rid of the built-in defaults; new installed themes will still appear.)
vim.g.theme_disallowlist = {
  "darkblue",
  "default",
  "delek",
  "desert",
  "evening",
  "habamax",
  "industry",
  "koehler",
  "lunaperche",
  "morning",
  "murphy",
  "pablo",
  "peachpuff",
  "quiet",
  "ron",
  "shine",
  "slate",
  "torte",
  "vim",
  "wildcharm",
  "zaibatsu",
  "zellner",
}

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

