local log = require("header42.log")

local M = {}

local function textwidth()
  local TEXTWIDTH_FALLBACK = 80

  if vim.bo.textwidth == nil or vim.bo.textwidth == 0 then
    local message = "Textwidth is not set, falling back to "
      .. tostring(TEXTWIDTH_FALLBACK)
      .. ".\n"
      .. "Configure the textwidth in `after/ftplugin/`."

    local opts = {
      id = "textwidth_not_set",
    }

    log.warn(message, opts)

    return TEXTWIDTH_FALLBACK
  else
    return vim.bo.textwidth
  end
end

--- This function returns the filename.
---@return string
local function format_filename()
  local name = vim.fn.expand("%:t")
  if string.len(name) == 0 then
    name = "< new >"
  end
  return name
end

--- This function returns the datetime.
---@param time number?
---@return string
local function format_datetime(time)
  if time == nil then
    return vim.fn.strftime("%Y/%m/%d %H:%M:%S")
  else
    return vim.fn.strftime("%Y/%m/%d %H:%M:%S", time)
  end
end

--- This function returns a single line of the header.
---@param open string
---@param left string
---@param right string
---@param close string
---@return string
local function combine_line_parts(open, left, right, close)
  local MARGIN = 5

  return open
    .. string.rep(" ", MARGIN - string.len(open))
    .. left
    .. string.rep(" ", textwidth() - MARGIN * 2 - string.len(left) - string.len(right))
    .. right
    .. string.rep(" ", MARGIN - string.len(close))
    .. close
end

--- This function returns a specific line of the header.
---@param config header42.Config
---@param i integer
---@return string?
local function create_line(config, i)
  local open, filler, close = require("header42.config").get_commentstring(config, vim.bo.filetype)
  local ascii = config.asciiart[i - 1]

  if i == 0 or i == 10 then
    local middle = string.rep(filler, textwidth() - string.len(open) - string.len(close) - 2)
    return open .. " " .. middle .. " " .. close
  elseif i == 1 or i == 9 then
    return combine_line_parts(open, " ", " ", close)
  elseif i == 2 or i == 4 or i == 6 then
    return combine_line_parts(open, " ", ascii, close)
  elseif i == 3 then
    return combine_line_parts(open, format_filename(), ascii, close)
  elseif i == 5 then
    local left = "By: "
      .. require("header42.config").get_username(config)
      .. " <"
      .. require("header42.config").get_email(config)
      .. ">"
    return combine_line_parts(open, left, ascii, close)
  elseif i == 7 then
    local left = "Created: " .. format_datetime() .. " by " .. require("header42.config").get_username(config)
    return combine_line_parts(open, left, ascii, close)
  elseif i == 8 then
    local left = "Updated: " .. format_datetime() .. " by " .. require("header42.config").get_username(config)
    return combine_line_parts(open, left, ascii, close)
  end
end

--- This function sets a specific line of the header.
---@param config header42.Config
---@param i integer
---@param replace boolean
local function set_line(config, i, replace)
  if replace then
    vim.api.nvim_buf_set_lines(0, i, i + 1, false, { create_line(config, i) })
  else
    vim.api.nvim_buf_set_lines(0, i, i, false, { create_line(config, i) })
  end
end

--- This function updates the filename in the header.
---@param config header42.Config
local function update_filename(config)
  local lines = vim.api.nvim_buf_get_lines(0, 3, 4, true)
  if lines == nil then
    return
  end

  local line = lines[1]
  local ascii_repl = string.gsub(config.asciiart[2], "(%+)", "%%%+")
  local pattern = "%s+(%S+)%s+" .. ascii_repl .. "%s+"
  local _, _, captured = string.find(line, pattern)
  if captured == nil then
    log.warn("Failed to capture filename.")
    return
  end

  if captured ~= format_filename() then
    set_line(config, 3, true)
  end
end

--- This function updates the modification datetime in the header.
---@param config header42.Config
local function update_modification_datetime(config)
  local lines = vim.api.nvim_buf_get_lines(0, 8, 9, true)
  if lines == nil then
    return
  end

  local line = lines[1]
  local pattern = "%s+Updated: (%d%d%d%d/%d%d/%d%d %d%d:%d%d:%d%d) by " .. "%S+" .. "%s+" .. config.asciiart[7] .. "%s+"
  local _, _, captured = string.find(line, pattern)
  if captured == nil then
    log.warn("Failed to capture modification datetime.")
    return
  end

  local is_modified = vim.api.nvim_get_option_value("modified", { buf = 0 })
  if is_modified then
    set_line(config, 8, true)
  end
end

local function is_modifiable()
  local result = vim.api.nvim_get_option_value("modifiable", {})

  if not result then
    log.error("The current buffer is read-only.")
  end

  return result
end

--- This function inserts the header to the top of the file.
---@param config header42.Config
function M.insert(config)
  if not is_modifiable() then
    return
  end

  for i = 0, 10, 1 do
    set_line(config, i, false)
  end
end

--- This function updates the header.
---@param config header42.Config
function M.update(config)
  if not is_modifiable() then
    return
  end

  update_filename(config)
  update_modification_datetime(config)
end

return M
