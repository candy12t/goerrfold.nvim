local M = {}

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
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local fold_regions = {}

  for i, line in ipairs(lines) do
    -- if err != nil {...}
    if line:match("if%s+err%s+!=%s+nil%s*{") then
      local start_line = i
      local end_line = M.find_closing_brace(lines, i)

      if end_line then
        table.insert(fold_regions, { start_line = start_line, end_line = end_line })
      end
    end

    -- if err := doSomething(); err != nil {...}
    if line:match("if%s+err%s*:=%s*.+;%s*err%s+!=%s+nil%s*{") then
      local start_line = i
      local end_line = M.find_closing_brace(lines, i)

      if end_line then
        table.insert(fold_regions, { start_line = start_line, end_line = end_line })
      end
    end
  end

  return fold_regions
end

function M.create_fold(start_line, end_line)
  vim.cmd(string.format([[%d,%dfold]], start_line, end_line))
end

function M.find_closing_brace(lines, start_line)
  local depth = 0
  local in_block = false

  for i = start_line, #lines do
    local line = lines[i]

    for _ in line:gmatch("{") do
      depth = depth + 1
      in_block = true
    end

    for _ in line:gmatch("}") do
      depth = depth - 1
      if in_block and depth == 0 then
        return i
      end
    end
  end

  return nil
end

return M
