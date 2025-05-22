local M = {}

local treesitter = require("goerrfold.treesitter")

function M.fold()
  local fold_regions = M.detect_error_handling_blocks()

  for _, region in ipairs(fold_regions) do
    if vim.fn.foldclosed(region.start_line) <= 0 then
      M.create_fold(region.start_line, region.end_line)
    end
  end
end

function M.unfold()
  vim.cmd("normal! zR")
end

function M.toggle()
  local has_folded_errors = false
  local fold_regions = M.detect_error_handling_blocks()

  for _, region in ipairs(fold_regions) do
    if vim.fn.foldclosed(region.start_line) > 0 then
      has_folded_errors = true
      break
    end
  end

  if has_folded_errors then
    M.unfold()
  else
    M.fold()
  end
end

function M.detect_error_handling_blocks()
  local buf = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(buf, "go")
  local tree = parser:parse()[1]
  local root = tree:root()

  local fold_regions = {}

  for _, node, _ in treesitter.query:iter_captures(root, buf, 0, -1) do
    local start_row, _, end_row, _ = node:range()
    table.insert(fold_regions, {
      start_line = start_row + 1,
      end_line = end_row + 1,
    })
  end

  return fold_regions
end

function M.create_fold(start_line, end_line)
  vim.cmd(string.format([[%d,%dfold]], start_line, end_line))
end

return M
