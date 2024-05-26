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
      vim.api.nvim_set_current_line(newline)
    end
    i = i + 1
  end
end

-- convert markdown text which is from clipboard to latex text with pandoc
local function TextConvert(f, t, sel)
  local handle
  if sel == true then
    local vstext = require("helper").get_visual_selection()
    handle = io.popen(('echo "%s" | pandoc --listings --from=%s --to=%s'):format(vstext, f, t))
  else
    handle = io.popen("xclip -out | pandoc --listings --from=" .. f .. " --to=" .. t)
  end
  local text
  if handle ~= nil then
    text = handle:read("*a")
    handle:close()
    local lines = {}
    for line in text:gmatch("([^\n]*)\n?") do
      table.insert(lines, line)
    end
    if sel == true then
      local s_start = vim.fn.getpos("'<")
      local s_end = vim.fn.getpos("'>")
      vim.cmd(("%d,%dd"):format(s_start[2] - 1, s_end[2]))
    end
    vim.api.nvim_put(lines, "", false, true)
  end
end

function Md2Tex()
  TextConvert("markdown", "latex")
end

function Tex2Md()
  TextConvert("latex", "markdown")
end

function VMd2Tex()
  TextConvert("markdown", "latex", true)
end

function VTex2Md()
  TextConvert("latex", "markdown", true)
end
