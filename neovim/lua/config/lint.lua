local M = {}

local function shellescape(s)
  return vim.fn.shellescape(s)
end

local function config_root()
  return vim.fn.stdpath("config")
end

local function eslint_config_path()
  return config_root() .. "/eslint/eslint.config.mjs"
end

local function extract_script_path()
  return config_root() .. "/scripts/extract_js_from_html.mjs"
end

local function run_job_to_quickfix(cmd, title)
  local output = {}
  local jid = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_exit = function(_, code)
      -- Feed output to errorformat parsing.
      vim.fn.setqflist({}, " ", {
        title = title .. " (exit " .. tostring(code) .. ")",
        lines = output,
        -- eslint -f unix:
        -- path:line:col: message [rule]
        efm = "%f:%l:%c: %m",
      })
      vim.cmd("copen")
      if code == 0 then
        vim.notify(title .. ": OK", vim.log.levels.INFO)
      else
        vim.notify(title .. ": issues found", vim.log.levels.WARN)
      end
    end,
  })

  if jid <= 0 then
    vim.notify("Failed to start job: " .. vim.inspect(cmd), vim.log.levels.ERROR)
  end
end

-- Lint JS inside an HTML file without any Neovim lint plugin:
-- - extracts JS while preserving line numbers
-- - runs ESLint via npx (downloads eslint if missing)
function M.lint_html_js(bufnr)
  bufnr = bufnr or 0
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" then
    vim.notify("Save the file before linting", vim.log.levels.WARN)
    return
  end

  local node = vim.fn.exepath("node")
  if node == "" then
    vim.notify("node not found in PATH (needed for HTML->JS extraction)", vim.log.levels.ERROR)
    return
  end

  local extractor = extract_script_path()
  local cfg = eslint_config_path()

  local title = "ESLint (JS-in-HTML)"

  -- PowerShell/cmd quoting is painful; use a list-form job with a shell pipeline by invoking a shell.
  -- We'll do: node extractor file | npx -y -p eslint eslint ... --stdin --stdin-filename <file>
  local is_windows = (vim.fn.has("win32") == 1)

  if is_windows then
    local ps = vim.fn.exepath("powershell")
    if ps == "" then
      vim.notify("powershell not found", vim.log.levels.ERROR)
      return
    end
    local script = table.concat({
      "& " .. shellescape(node) .. " " .. shellescape(extractor) .. " " .. shellescape(file),
      "|",
      "npx --yes -p eslint eslint -c " .. shellescape(cfg) .. " -f unix --stdin --stdin-filename " .. shellescape(file),
    }, " ")
    run_job_to_quickfix({ ps, "-NoProfile", "-NonInteractive", "-Command", script }, title)
  else
    local sh = vim.fn.exepath("sh")
    if sh == "" then
      vim.notify("sh not found", vim.log.levels.ERROR)
      return
    end
    local script = table.concat({
      shellescape(node) .. " " .. shellescape(extractor) .. " " .. shellescape(file),
      "|",
      "npx --yes -p eslint eslint -c " .. shellescape(cfg) .. " -f unix --stdin --stdin-filename " .. shellescape(file),
    }, " ")
    run_job_to_quickfix({ sh, "-lc", script }, title)
  end
end

function M.lint_current()
  local bufnr = 0
  local ft = vim.bo[bufnr].filetype
  if ft == "html" then
    return M.lint_html_js(bufnr)
  end
  vim.notify("No linter configured for filetype: " .. ft, vim.log.levels.WARN)
end

return M

