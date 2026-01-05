local M = {}

-- Minimal “LLM agent” integration that talks to a local server you run.
-- You control the server + auth; Neovim just does HTTP.
--
-- Expected endpoint:
--   POST http://127.0.0.1:8080/v1/chat
-- Body:
--   { "prompt": "...", "filetype": "lua", "selection": "...", "filename": "..." }
-- Response:
--   { "text": "..." }

local function have_curl()
  return vim.fn.exepath("curl") ~= ""
end

local function json_encode(tbl)
  return vim.json.encode(tbl)
end

local function json_decode(str)
  return vim.json.decode(str)
end

local function get_visual_selection()
  local _, ls, cs = unpack(vim.fn.getpos("'<"))
  local _, le, ce = unpack(vim.fn.getpos("'>"))
  if ls == 0 or le == 0 then
    return ""
  end
  if ls > le or (ls == le and cs > ce) then
    ls, le, cs, ce = le, ls, ce, cs
  end
  local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  if #lines == 0 then
    return ""
  end
  lines[1] = string.sub(lines[1], cs)
  lines[#lines] = string.sub(lines[#lines], 1, ce)
  return table.concat(lines, "\n")
end

local function llm_url()
  return vim.g.llm_server_url or "http://127.0.0.1:8080/v1/chat"
end

local function run(prompt, selection, on_done)
  if not have_curl() then
    vim.notify("curl not found in PATH (needed for local LLM HTTP)", vim.log.levels.ERROR)
    return
  end
  local body = json_encode({
    prompt = prompt,
    filetype = vim.bo.filetype,
    selection = selection or "",
    filename = vim.api.nvim_buf_get_name(0),
  })

  local cmd = {
    "curl",
    "-sS",
    "-X",
    "POST",
    "-H",
    "Content-Type: application/json",
    "--data-binary",
    body,
    llm_url(),
  }

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      local text = table.concat(data or {}, "\n")
      if text == "" then
        return
      end
      local ok, decoded = pcall(json_decode, text)
      if ok and decoded and type(decoded.text) == "string" then
        on_done(decoded.text)
      else
        -- Fallback: treat as plain text
        on_done(text)
      end
    end,
    on_stderr = function(_, data)
      local err = table.concat(data or {}, "\n")
      if err ~= "" then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end,
  })
end

function M.prompt()
  local selection = ""
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    selection = get_visual_selection()
  end

  vim.ui.input({ prompt = "LLM prompt: " }, function(input)
    if not input or input == "" then
      return
    end
    run(input, selection, function(text)
      -- Put response into a scratch buffer
      vim.cmd("vnew")
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "wipe"
      vim.bo.swapfile = false
      vim.bo.filetype = "markdown"
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(text, "\n", { plain = true }))
      vim.cmd("normal! gg")
    end)
  end)
end

return M


