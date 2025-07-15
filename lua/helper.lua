local M = {}

-- lines: list of lines to be inserted.
-- new_pos: the new cursor position will be set.
-- currnet: if current is true then the current line will 
-- be replaced by the first line.
function M.insert_lines(lines, new_pos, replace)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local len = #lines
  if new_pos[1] == -1 then new_pos[1] = row + math.ceil(len / 2) end
  if new_pos[2] == -1 then new_pos[2] = col end
  if replace == true then
    -- This is a destructive operation, it will replace all 
    -- lines from row to row + len.
    vim.api.nvim_buf_set_lines(0, row - 1, row + len, false, lines)
  else
    for _, c in pairs(lines) do
      -- Insert line to current buffer, not replace exist lines
      vim.api.nvim_buf_set_lines(0, row, row, false, {c})
      row = row + 1
    end
  end
  vim.api.nvim_win_set_cursor(0, new_pos)
end

-- cb: the callback used to change the text
M.replace_text_under_cursor = function(cb)
  local saved_cursor = vim.api.nvim_win_get_cursor(0)
  local cline = vim.fn.getline(".")
  if cline == "" then return end
  local cword = vim.fn.escape(vim.fn.expand('<cword>'), [[\/]])
  local cwlen = cword:len()
  if cwlen == 0 then return end
  local s = saved_cursor[2] > cwlen and
            saved_cursor[2] - cwlen or 0

  -- find the exact start index of cword
  local _s, _ = cline:find(cword, s, true)
  if _s == nil then
    return
  end
  local pre = cline:sub(1, _s-1)
  local post = cline:sub(_s)

  local nword = cb(cword)

  post = post:gsub(cword, nword, 1)
  vim.fn.setline(saved_cursor[1], pre..post)
  vim.api.nvim_win_set_cursor(0, saved_cursor)
end

function M.visual_selection(replace)
  local saved_reg = vim.fn.getreg('"')
  vim.cmd("normal! vgvy")

  local pattern = vim.fn.escape(vim.fn.getreg('"'), "\\/.*'$^~[]")
  pattern = vim.fn.substitute(pattern, "\n$", "", "")

  if replace == true then
    vim.fn.feedkeys(":%s/" .. pattern .. "/")
  end

  vim.fn.setreg("/", pattern)
  vim.fn.setreg('"', saved_reg)
end

function M.insert_header()
  local author = vim.fn.trim(vim.fn.system('git config user.name'))
  if author == '' then
    author = '[Your name]'
  end
  local curdate = vim.fn.strftime('%Y')
  local copyright = string.format("Copyright © %s %s. All Rights Reserved.",
    curdate, author)
  local script_env = '#!/usr/bin/env'

  local headers
  local row = 3
  if vim.bo.filetype == 'sh' then
    headers = {
      string.format("%s bash", script_env),
      "", "",
    }
  elseif vim.bo.filetype == 'python' then
    headers = {
      string.format("%s python", script_env),
      "", "",
    }
  else
    headers = {
      "/*",
      string.format(' * %s', copyright),
      " */", "", "",
    }
  end
  if vim.fn.expand("%:e") == 'c' then
    headers[#headers+1] = "#include <stdio.h>"
    headers[#headers+1] = "#include <stdint.h>"
    headers[#headers+1] = "#include <stdlib.h>"
    headers[#headers+1] = ""
    headers[#headers+1] = "int main(int argc, char *argv[])"
    headers[#headers+1] = "{"
    headers[#headers+1] = "\t;"
    row = #headers
    headers[#headers+1] = ""
    headers[#headers+1] = "\treturn 0;"
    headers[#headers+1] = "}"
  end
  if vim.fn.expand("%:e") == 'h' then
    -- If special characters in file name, we replace them
    -- with `_`.
    -- NOTE: YOU SHOULD NOT USE SPECIAL CHARACTERS
    -- TO CREATE NEW FILE NAME.
    local hdef = vim.fn.expand("%:t"):
          gsub("[~!@#&=,'|\"\\%$%.%-%+%?%*%^%%]+", "_"):upper()
    headers[#headers+1] = string.format("#ifndef __%s", hdef)
    headers[#headers+1] = string.format("#define __%s", hdef)
    headers[#headers+1] = ""
    headers[#headers+1] = ""
    row = #headers
    headers[#headers+1] = ""
    headers[#headers+1] = "#endif"
  end
  if vim.fn.expand("%:e") == 'cpp' or vim.fn.expand("%:e") == 'cc' then
    headers[#headers+1] = "#include <iostream>"
    -- headers[#headers+1] = "using namespace std;"
    headers[#headers+1] = ""
    headers[#headers+1] = ""
    row = #headers
  end
  if vim.fn.expand("%:e") == 'hpp' then
    vim.fn.append(vim.fn.line(".") + 4, "#pragma once")
    headers[#headers+1] = "#pragma once"
    headers[#headers+1] = ""
    headers[#headers+1] = ""
    row = #headers
  end
  M.insert_lines(headers, {row, 8}, true)
end

function M.update_header()
  local author = vim.fn.trim(vim.fn.system('git config user.name'))
  if author == '' then
    author = '[Your name]'
  end
  local curdate = vim.fn.strftime('%Y')
  local crline = vim.fn.getline(2)
  local olddate_h = vim.fn.matchstr(crline, ' [0-9]\\{4}', 3)
  local olddate_t = vim.fn.matchstr(crline, '-[0-9]\\{4}', 3)
  local newdate_h = ' ' .. curdate
  local newdate_t = '-' .. curdate
  local s, e = string.find(crline, author, nil, true)
  if s ~= nil and e ~= nil and e > s then
    if olddate_t ~= '' and olddate_t < newdate_t then
      local new_data_str = newdate_t
      vim.fn.setline(2, vim.fn.substitute(crline, olddate_t, new_data_str, ''))
    elseif olddate_h ~= '' and olddate_h < newdate_h then
      if vim.fn.match(crline, '[0-9]\\{4}-') < 0 then
        local new_data_str = olddate_h .. newdate_t
        vim.fn.setline(2, vim.fn.substitute(crline, olddate_h, new_data_str, ''))
      end
    end
  end
end

function M.get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

return M
