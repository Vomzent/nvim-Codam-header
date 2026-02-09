local M = {}

--- This function executes a system command, waits until it completes, and returns stdout.
---@param command string[]
---@return string?
local function execute(command)
  local object = vim.system(command, { text = true }):wait()
  local stdout = vim.trim(object.stdout)

  if object.code ~= 0 or stdout == "" then
    return nil
  end

  return stdout
end

--- This function returns the git username.
---@return string?
function M.username()
  return execute({
    "git",
    "config",
    "user.name",
  })
end

--- This function returns the git email address.
---@return string?
function M.email()
  return execute({
    "git",
    "config",
    "user.email",
  })
end

return M
