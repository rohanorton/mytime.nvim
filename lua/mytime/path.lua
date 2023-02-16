local M = {}

M.seperator = function()
  -- TODO: Currently only works on unix-like systems
  return "/"
end

M.join = function(...)
  local path = table.concat({ ... }, M.seperator())
  return vim.fn.resolve(path)
end

return M
