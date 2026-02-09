local M = {}

local PLUGIN_NAME = "header42.nvim"

--- This function displays a message.
---@param message string
---@param level vim.log.levels
---@param opts table?
local function notify(message, level, opts)
  opts = vim.tbl_deep_extend("keep", { title = PLUGIN_NAME }, opts or {})

  vim.notify(message, level, opts)
end

--- This function displays an error message.
---@param message string
---@param opts table?
function M.error(message, opts)
  notify(message, vim.log.levels.ERROR, opts)
end

--- This function displays a warn message.
---@param message string
---@param opts table?
function M.warn(message, opts)
  notify(message, vim.log.levels.WARN, opts)
end

--- This function displays an info message.
---@param message string
---@param opts table?
function M.info(message, opts)
  notify(message, vim.log.levels.INFO, opts)
end

--- This function displays a debug message.
---@param message string
---@param opts table?
function M.debug(message, opts)
  notify(message, vim.log.levels.DEBUG, opts)
end

--- This function displays a trace message.
---@param message string
---@param opts table?
function M.trace(message, opts)
  notify(message, vim.log.levels.TRACE, opts)
end

return M
