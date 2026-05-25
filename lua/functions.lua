-- Run a command to process lines starting from cursor
-- @param cmd: command to execute
-- @param lnum: number of lines to process
function ReplaceLineWithCmd(cmd, lnum)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  for i = row, row + lnum - 1 do
    vim.api.nvim_win_set_cursor(0, { i, col })
    local line = vim.api.nvim_get_current_line()
    local escaped_line = line:gsub('"', '\\"')
    local command = string.format('%s "%s"', cmd, escaped_line)

    local handle = io.popen(command)
    if handle then
      local newline = handle:read "*a"
      handle:close()
      if newline then
        vim.api.nvim_set_current_line(newline:gsub("\n$", ""))
      end
    end
  end
end

-- Convert text format using pandoc
-- @param from: source format
-- @param to: target format
-- @param use_selection: if true, use visual selection; otherwise use clipboard
local function TextConvert(from, to, use_selection)
  local pandoc_cmd = "pandoc --listings --from=%s --to=%s"
  local command

  if use_selection then
    local visual_text = require("helper").get_visual_selection()
    command = string.format('echo "%s" | ' .. pandoc_cmd, visual_text, from, to)
  else
    command = string.format("xclip -out | " .. pandoc_cmd, from, to)
  end

  local handle = io.popen(command)
  if not handle then
    return
  end

  local text = handle:read "*a"
  handle:close()

  if not text or text == "" then
    return
  end

  -- Split text into lines
  local lines = {}
  for line in text:gmatch "([^\n]*)\n?" do
    table.insert(lines, line)
  end

  -- Replace selection if using visual selection
  if use_selection then
    local s_start = vim.fn.getpos "'<"
    local s_end = vim.fn.getpos "'>"
    vim.cmd(string.format("%d,%dd", s_start[2], s_end[2]))
  end

  vim.api.nvim_put(lines, "", false, true)
end

-- Conversion functions
function Md2Tex()
  TextConvert("markdown", "latex", false)
end

function Tex2Md()
  TextConvert("latex", "markdown", false)
end

function VMd2Tex()
  TextConvert("markdown", "latex", true)
end

function VTex2Md()
  TextConvert("latex", "markdown", true)
end

function ToUTF8()
  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then
    print "No file name available"
    return
  end

  -- Detect encoding
  local uchardet_cmd = string.format("uchardet '%s' 2>/dev/null", filename)
  local handle = io.popen(uchardet_cmd)

  if not handle then
    print "Failed to run uchardet"
    return
  end

  local encoding = handle:read("*a"):gsub("[ \n]", "")
  handle:close()

  if encoding == "" then
    print "uchardet: cannot detect file encoding"
    return
  end

  -- Convert to UTF-8
  local iconv_cmd = string.format("iconv -f %s -t utf-8 '%s' -o '%s'", encoding, filename, filename)
  os.execute(iconv_cmd)
  vim.cmd ":edit!"
end
