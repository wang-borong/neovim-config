local M = {}

-- Insert lines into buffer at cursor position
-- @param lines: list of lines to be inserted
-- @param new_pos: the new cursor position {row, col}, use -1 for auto
-- @param replace: if true, replace existing lines; otherwise insert
function M.insert_lines(lines, new_pos, replace)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local len = #lines
  
  -- Auto-calculate position if needed
  if new_pos[1] == -1 then
    new_pos[1] = row + math.ceil(len / 2)
  end
  if new_pos[2] == -1 then
    new_pos[2] = col
  end
  
  if replace then
    vim.api.nvim_buf_set_lines(0, row - 1, row + len, false, lines)
  else
    for _, line in ipairs(lines) do
      vim.api.nvim_buf_set_lines(0, row, row, false, { line })
      row = row + 1
    end
  end
  vim.api.nvim_win_set_cursor(0, new_pos)
end

-- Replace text under cursor using callback function
-- @param cb: callback function that takes current word and returns new word
M.replace_text_under_cursor = function(cb)
  local saved_cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = vim.fn.getline(".")
  
  if current_line == "" then
    return
  end
  
  local current_word = vim.fn.escape(vim.fn.expand('<cword>'), [[\/]])
  if current_word:len() == 0 then
    return
  end
  
  -- Find word start position
  local search_start = saved_cursor[2] > current_word:len() and saved_cursor[2] - current_word:len() or 0
  local word_start, _ = current_line:find(current_word, search_start, true)
  
  if not word_start then
    return
  end
  
  local prefix = current_line:sub(1, word_start - 1)
  local suffix = current_line:sub(word_start)
  local new_word = cb(current_word)
  
  suffix = suffix:gsub(current_word, new_word, 1)
  vim.fn.setline(saved_cursor[1], prefix .. suffix)
  vim.api.nvim_win_set_cursor(0, saved_cursor)
end

function M.visual_selection(replace)
  local saved_reg = vim.fn.getreg('"')
  vim.cmd("normal! vgvy")

  local pattern = vim.fn.escape(vim.fn.getreg('"'), "\\/.*'$^~[]")
  pattern = vim.fn.substitute(pattern, "\n$", "", "")

  if replace then
    vim.fn.feedkeys(":%s/" .. pattern .. "/")
  end

  vim.fn.setreg("/", pattern)
  vim.fn.setreg('"', saved_reg)
end

-- Get git author name or default
local function get_author()
  local author = vim.fn.trim(vim.fn.system('git config user.name'))
  return author ~= '' and author or '[Your name]'
end

-- Get copyright string
local function get_copyright()
  local author = get_author()
  local year = vim.fn.strftime('%Y')
  return string.format("Copyright © %s %s. All Rights Reserved.", year, author)
end

-- Create shebang header based on filetype
local function create_shebang_header(filetype)
  local interpreters = {
    sh = "bash",
    python = "python",
  }
  local interpreter = interpreters[filetype]
  if interpreter then
    return { string.format("#!/usr/bin/env %s", interpreter), "", "" }
  end
  return {
    "/*",
    string.format(' * %s', get_copyright()),
    " */", "", "",
  }
end

-- Add C-specific headers and main function
local function add_c_headers(headers)
  table.insert(headers, "#include <stdio.h>")
  table.insert(headers, "#include <stdint.h>")
  table.insert(headers, "#include <stdlib.h>")
  table.insert(headers, "")
  table.insert(headers, "int main(int argc, char *argv[])")
  table.insert(headers, "{")
  table.insert(headers, "\t;")
  table.insert(headers, "")
  table.insert(headers, "\treturn 0;")
  table.insert(headers, "}")
  return #headers
end

-- Add C header guard
local function add_c_header_guard(headers)
  local filename = vim.fn.expand("%:t")
  local guard = filename:gsub("[~!@#&=,'|\"\\%$%.%-%+%?%*%^%%]+", "_"):upper()
  table.insert(headers, string.format("#ifndef __%s", guard))
  table.insert(headers, string.format("#define __%s", guard))
  table.insert(headers, "")
  table.insert(headers, "")
  table.insert(headers, "")
  table.insert(headers, "#endif")
  return #headers - 1
end

-- Add C++ headers
local function add_cpp_headers(headers)
  table.insert(headers, "#include <iostream>")
  table.insert(headers, "")
  table.insert(headers, "")
  return #headers
end

-- Add C++ header pragma
local function add_cpp_header_pragma(headers)
  table.insert(headers, "#pragma once")
  table.insert(headers, "")
  table.insert(headers, "")
  return #headers
end

function M.insert_header()
  local filetype = vim.bo.filetype
  local extension = vim.fn.expand("%:e")
  local headers = create_shebang_header(filetype)
  local row = 3

  -- Add file extension-specific headers
  if extension == 'c' then
    row = add_c_headers(headers)
  elseif extension == 'h' then
    row = add_c_header_guard(headers)
  elseif extension == 'cpp' or extension == 'cc' then
    row = add_cpp_headers(headers)
  elseif extension == 'hpp' then
    row = add_cpp_header_pragma(headers)
  end

  M.insert_lines(headers, { row, 8 }, true)
end

function M.update_header()
  local author = get_author()
  local current_year = vim.fn.strftime('%Y')
  local copyright_line = vim.fn.getline(2)
  
  -- Check if author is in the line
  local author_start, author_end = string.find(copyright_line, author, nil, true)
  if not author_start or author_end <= author_start then
    return
  end

  -- Match date patterns
  local single_year_pattern = ' ([0-9]\\{4})'
  local year_range_pattern = '-([0-9]\\{4})'
  local old_single_year = vim.fn.matchstr(copyright_line, single_year_pattern, 3)
  local old_end_year = vim.fn.matchstr(copyright_line, year_range_pattern, 3)
  
  local new_single_year = ' ' .. current_year
  local new_end_year = '-' .. current_year

  -- Update year range if exists and needs update
  if old_end_year ~= '' and old_end_year < new_end_year then
    vim.fn.setline(2, vim.fn.substitute(copyright_line, old_end_year, new_end_year, ''))
  -- Update single year to range if needed
  elseif old_single_year ~= '' and old_single_year < new_single_year then
    if vim.fn.match(copyright_line, '[0-9]\\{4}-') < 0 then
      local new_year_str = old_single_year .. new_end_year
      vim.fn.setline(2, vim.fn.substitute(copyright_line, old_single_year, new_year_str, ''))
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
