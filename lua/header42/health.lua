local M = {}

--- This function checks the health of the plugin configuration.
function M.check()
  vim.health.start("header42.nvim report")

  local header42 = require("header42")
  local config = require("header42.config")

  local success, error = pcall(config.validate, header42.config)
  if success then
    vim.health.ok("configuration is valid")
  else
    vim.health.error("invalid configuration: " .. error)
  end

  local filetypes = {
    "c",
    "cpp",
    "python",
  }

  for _, ft in ipairs(filetypes) do
    local textwidth = vim.filetype.get_option(ft, "textwidth")
    if textwidth == nil or textwidth == 0 then
      vim.health.warn("textwidth not set for " .. ft)
    end
  end
end

return M
