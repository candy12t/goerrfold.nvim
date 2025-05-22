local M = {}

function M.setup()
  M.query = vim.treesitter.query.parse("go", M.get_queries())
end

---@return string
function M.get_queries()
  local plugin_dir = string.sub(debug.getinfo(1).source, 2, string.len("/treesitter.lua") * -1)
  local query_path = plugin_dir .. "queries/go.scm"

  local file = io.open(query_path, "r")
  local queries = file:read("*all")
  file:close()

  return queries
end

return M
