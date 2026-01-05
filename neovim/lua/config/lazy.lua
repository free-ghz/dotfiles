-- Plugin manager bootstrap (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorscheme

  {
    "https://git.sr.ht/~romainl/vim-bruin",
    name = "vim-bruin",
    lazy = false,
  },
  {
    "https://github.com/zautumnz/angr.vim",
    name = "angr",
    lazy = false,
  },



  -- Treesitter (syntax highlighting foundation; also useful for your nesting-level engine later)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- nvim-treesitter recently changed its public Lua API.
      -- Old: require("nvim-treesitter.configs").setup({ ...modules... })
      -- New: require("nvim-treesitter").setup({ ...core config... })
      local ok_old, configs = pcall(require, "nvim-treesitter.configs")
      if ok_old and configs and configs.setup then
        configs.setup({
          highlight = { enable = true },
          indent = { enable = true },
        })
      else
        local ok_new, ts = pcall(require, "nvim-treesitter")
        if ok_new and ts and ts.setup then
          ts.setup({})
        end

        -- Enable built-in Tree-sitter highlighting when a parser exists.
        -- (Safe no-op if your Neovim version doesn't support this API.)
        if vim.treesitter and vim.treesitter.start then
          vim.api.nvim_create_augroup("ts_start_highlight", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
            group = "ts_start_highlight",
            callback = function(args)
              pcall(vim.treesitter.start, args.buf)
            end,
          })
        end
      end
    end,
  },

  -- EasyMotion
  {
    "easymotion/vim-easymotion",
    init = function()
      vim.g.EasyMotion_do_mapping = 0
    end,
    config = function()
      local map = vim.keymap.set
      map("n", "s", "<Plug>(easymotion-s2)", { silent = true, desc = "EasyMotion: 2-char search" })
      map("n", "S", "<Plug>(easymotion-overwin-f2)", { silent = true, desc = "EasyMotion: overwin 2-char" })
      map("n", "<leader>j", "<Plug>(easymotion-j)", { silent = true, desc = "EasyMotion: down" })
      map("n", "<leader>k", "<Plug>(easymotion-k)", { silent = true, desc = "EasyMotion: up" })
    end,
  },

  -- Fuzzy file picker (modern "open file" UX). This does NOT add HTML tag autocompletion.
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      require("telescope").setup({
        defaults = {
          -- If you hate "big centered floats", this feels more like a panel.
          layout_strategy = "bottom_pane",
          layout_config = { height = 0.45 },
        },
      })
    end,
  },
})

