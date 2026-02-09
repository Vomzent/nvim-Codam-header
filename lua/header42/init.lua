local M = {}

--- This function creates the autocommand that will update the header automatically when saving.
---@param pattern string | string[]
local function create_autocmds(pattern)
  local group = vim.api.nvim_create_augroup("header42", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = pattern,
    desc = "Update the 42 header when saving",
    callback = function()
      M.update()
    end,
  })
end

--- This function configures the plugin.
---@param config header42.Config
function M.setup(config)
  M.config = require("header42.config").merge_config(config)

  if M.config.autocmd.create then
    create_autocmds(M.config.autocmd.pattern)
  end
end

--- This function creates a new header.
function M.insert()
  require("header42.header").insert(M.config)
end

--- This function updates the header, creating a new one if not present.
function M.update()
  if vim.api.nvim_buf_line_count(0) < 11 then
    require("header42.header").insert(M.config)
  else
    require("header42.header").update(M.config)
  end
end

return M
