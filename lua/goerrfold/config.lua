local M = {}

---@class Config
M.defaults = {
  -- Whether to automatically fold error handling blocks when the file is opened
  auto_fold = true,
  -- Whether to fold error handling blocks when the file is saved
  fold_on_save = true,
}

local options = {}

---@param opts? Config
function M.setup(opts)
  options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

---@return Config
function M.get()
  return options
end

return M
