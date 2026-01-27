local opt = vim.opt

-- Core UX
-- Use terminal's default color palette (disable 24-bit RGB colorscheme colors) by setting this to false. It will force color schemes to map onto the closest avaliable terminal color.
opt.termguicolors = true
opt.hidden = true
opt.updatetime = 200
opt.timeoutlen = 400

-- NO MOUSE. Ever.
opt.mouse = ""

-- Line numbers: absolute + relative (toggle relative via keymap)
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

-- Indentation: 4 spaces
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

-- Line endings / file formats:
-- Prefer unix, but allow reading dos.
opt.fileformats = { "unix", "dos" }
opt.fileformat = "unix"

-- Clipboard: keep portable; you can uncomment if you want system clipboard everywhere.
-- opt.clipboard = "unnamedplus"

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Wrapping
opt.wrap = false

-- Completion: keep it manual only (no popup automation from plugins; also keep sane menu behavior)
opt.completeopt = { "menuone", "noselect" }

-- Command-line completion (for :e, :cd, etc.)
opt.wildmenu = true
opt.wildmode = { "longest:full", "full" }

-- Show whitespace (always): spaces + tabs
opt.list = true
opt.listchars = {
  tab = "»·",
  space = "·",
  trail = "·",
  nbsp = "␣",
}

