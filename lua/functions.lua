-- Run a command to handle current line
function ReplaceLineWithCmd(cmd, lnum)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local i = row
  while i < row + lnum
  do
    vim.api.nvim_win_set_cursor(0, {i, col})
    local line = vim.api.nvim_get_current_line()
    local cmdline = line:gsub("\"", "\\\"")
    local newline
    local handle = io.popen(cmd .. " \"" .. cmdline .. "\"")
    if handle ~= nil then
      newline = handle:read("*a")
      handle:close()
    else
      newline = line
    end
    vim.api.nvim_set_current_line(newline)
    i = i + 1
  end
end
