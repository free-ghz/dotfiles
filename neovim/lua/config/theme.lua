local M = {}

-- Theme picker filtering.
--
-- Preferred: DISALLOWLIST (so new installed themes automatically appear)
--   vim.g.theme_disallowlist = { "blue", "darkblue", ... }
--
-- Optional: ALLOWLIST (strongest filter; if set, only these appear)
--   vim.g.theme_allowlist = { "tokyonight-night", "bruin", "distilled" }

local function get_all_schemes()
  return vim.fn.getcompletion("", "color")
end

local function normalize_list(list)
  if type(list) ~= "table" then
    return nil
  end
  if #list == 0 then
    return nil
  end
  local set = {}
  for _, v in ipairs(list) do
    if type(v) == "string" and v ~= "" then
      set[v] = true
    end
  end
  return set
end

local function filter_schemes(all, allowset, disallowset)
  local out = {}
  for _, name in ipairs(all) do
    if allowset then
      if allowset[name] then
        out[#out + 1] = name
      end
    elseif disallowset then
      if not disallowset[name] then
        out[#out + 1] = name
      end
    else
      out[#out + 1] = name
    end
  end
  return out
end

local function apply(name)
  if not name or name == "" then
    return
  end
  local ok, err = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.notify(("Failed to set colorscheme %q: %s"):format(name, err), vim.log.levels.ERROR)
  end
end

function M.pick()
  local all = get_all_schemes()
  local allowset = normalize_list(vim.g.theme_allowlist)
  local disallowset = normalize_list(vim.g.theme_disallowlist)
  local schemes = filter_schemes(all, allowset, disallowset)

  -- Prefer Telescope if installed.
  local ok, _ = pcall(require, "telescope")
  if ok then
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers
      .new({}, {
        prompt_title = "Colorscheme",
        finder = finders.new_table({ results = schemes }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if entry and entry[1] then
              apply(entry[1])
            end
          end)
          return true
        end,
      })
      :find()
    return
  end

  -- Fallback picker (built-in).
  vim.ui.select(schemes, { prompt = "Colorscheme" }, apply)
end

function M.apply(name)
  apply(name)
end

return M


