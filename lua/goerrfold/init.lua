local M = {}

local command = require("goerrfold.command")
local config = require("goerrfold.config")
local core = require("goerrfold.core")

function M.setup(opts)
  config.setup(opts)

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.go",
    callback = function()
      if config.get().auto_fold then
        core.fold()
      end

      command.setup()
    end,
  })

  if config.get().fold_on_save then
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      pattern = "*.go",
      callback = function()
        core.fold()
      end,
    })
  end
end

return M
