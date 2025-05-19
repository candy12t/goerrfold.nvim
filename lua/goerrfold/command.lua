local M = {}

local core = require("goerrfold.core")

M.commands = {
  fold = core.fold,
  unfold = core.unfold,
  toggle = core.toggle,
}

function M.setup()
  vim.api.nvim_create_user_command("GoErrFold", function(opts)
    M.execute(opts.args)
  end, {
    nargs = 1,
    complete = M.complete,
  })
end

---@param cmd string
---@return boolean
function M.execute(cmd)
  if M.commands[cmd] then
    M.commands[cmd]()
    return true
  end

  vim.notify("Unknown command: " .. cmd, vim.log.levels.ERROR)
  return false
end

---@return string[]
function M.complete()
  return vim.tbl_keys(M.commands)
end

return M
