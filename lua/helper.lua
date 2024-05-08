local M = {}

-- lines: list of lines to be inserted.
-- new_pos: the new cursor position will be set.
-- currnet: if current is true then the current line will 
-- be replaced by the first line.
function M.insert_lines(lines, new_pos, replace)
  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]
  local len = #lines
  if new_pos[1] == -1 then new_pos[1] = pos[1] + math.ceil(len / 2) end
  if new_pos[2] == -1 then new_pos[2] = pos[2] end
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

function M.visual_selection(replace)
  local saved_reg = vim.fn.getreg('"')
  vim.cmd("normal! vgvy")

  local pattern = vim.fn.escape(vim.fn.getreg('"'), "\\/.*'$^~[]")
  pattern = vim.fn.substitute(pattern, "\n$", "", "")

  if replace == true then
    vim.fn.feedkeys(":%s" .. '/' .. pattern .. '/')
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
  local pos = {3, 0}
  if vim.bo.filetype == 'sh' then
    headers = {
      string.format("%s bash", script_env),
      "",
      ""
    }
  elseif vim.bo.filetype == 'python' then
    headers = {
      string.format("%s python", script_env),
      "",
      ""
    }
  else
    headers = {
      "/*",
      string.format(' * %s', copyright),
      " */",
      "",
      "",
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
    pos[1] = #headers
    pos[2] = 8
    headers[#headers+1] = "\treturn 0;"
    headers[#headers+1] = "}"
  end
  if vim.fn.expand("%:e") == 'h' then
    local _hh = vim.fn.toupper(
      vim.fn.substitute(vim.fn.expand("%:t"), "\\.h", "_h", ""))
    headers[#headers+1] = string.format("#ifndef __%s", _hh)
    headers[#headers+1] = string.format("#define __%s", _hh)
    headers[#headers+1] = ""
    headers[#headers+1] = ""
    pos[1] = #headers
    headers[#headers+1] = ""
    headers[#headers+1] = "#endif"
  end
  if vim.fn.expand("%:e") == 'cpp' then
    headers[#headers+1] = "#include <iostream>"
    headers[#headers+1] = "using namespace std;"
    headers[#headers+1] = ""
    headers[#headers+1] = ""
    pos[1] = #headers
  end
  if vim.fn.expand("%:e") == 'hpp' then
    vim.fn.append(vim.fn.line(".") + 4, "#pragma once")
    headers[#headers+1] = "#pragma once"
    headers[#headers+1] = ""
    headers[#headers+1] = ""
    pos[1] = #headers
  end
  M.insert_lines(headers, pos, true)
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

return M
