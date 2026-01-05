## Neovim config (portable: Windows/macOS/Linux)

### Where this folder goes
- **Windows (native Neovim)**: `%LOCALAPPDATA%\nvim`
- **macOS/Linux**: `~/.config/nvim`

This repo is already that folder, so you’re good.

### What you asked for (implemented)
- **No mouse ever**: `set mouse=` (terminal selection works normally)
- **Line numbers absolute + relative**: both enabled; toggle relative with `<leader>nr`
- **Line endings**: defaults to **LF**; can switch per-file:
  - `<leader>fu` → LF
  - `<leader>fd` → CRLF
- **4 spaces**: `expandtab`, `shiftwidth=4`, `tabstop=4`
- **EasyMotion**:
  - `s` → 2-char jump
  - `S` → 2-char across windows
  - `<leader>j` / `<leader>k` → line jumps
- **No HTML autocompletion**: no completion plugins installed; no HTML LSP configured.
- **HTML5 void tags**: on save, converts `<img />` → `<img>` (and other void tags).
  - Disable with: `vim.g.html_void_no_slash = false`
- **JS linter runnable on HTML files (no Neovim lint plugin)**:
  - Press `<leader>l` in an `.html` buffer.
  - It extracts `<script>` JS while preserving line numbers, then runs ESLint via `npx`.
  - Requires **node** + **npx** in PATH.
- **LLM agent via local server**:
  - `<leader>ai` (normal/visual) sends prompt (and selection) to your local HTTP server.
  - Default URL: `http://127.0.0.1:8080/v1/chat`
  - Override in `init.lua` with: `vim.g.llm_server_url = "http://127.0.0.1:PORT/v1/chat"`
- **Nesting-level-only highlighting scaffold**:
  - Run `:NestingHLToggle` (off by default).
- **DreamWiki filetype (`*.dreamwiki`)**:
  - Gets its own filetype: `dreamwiki`
  - Adds multi-strength rulers (40 strongest, 20/30 medium, every 4 weak)
  - Minimal syntax scaffold in `syntax/dreamwiki.vim`

### First-time plugin install
On first launch, `lazy.nvim` will clone itself and install plugins automatically.
You need `git` available in PATH.

### Notes about WSL
You **do not need WSL** for this config. If you *prefer* WSL for a Linux-first environment:
- Put the same config under `~/.config/nvim` inside WSL.
- You’ll also want `git`, `node`, `curl` installed in WSL.

### Local LLM server (expected contract)
Neovim calls:
- **POST** `http://127.0.0.1:8080/v1/chat`
- JSON body:
  - `prompt` (string)
  - `filetype` (string)
  - `selection` (string)
  - `filename` (string)
- Response:
  - `{ "text": "..." }` (preferred) or plain text


