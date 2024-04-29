require "nvchad.options"

-- add yours here!

local o = vim.o
local autocmd = vim.api.nvim_create_autocmd
-- o.cursorlineo ='both' -- to enable cursorline!

o.smartcase = true
o.ignorecase = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.autoindent = true
o.cursorline = true
o.wrap = true
o.mouse = ""

vim.opt.iskeyword:append("-")

autocmd("FileType", {
  pattern = { "lua", "markdown", "tex" },
  callback = function()
    o.shiftwidth = 2
    o.tabstop = 2
  end,
})

autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    o.expandtab = true
		o.textwidth = 120
  end,
})

autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.c", "*.h" },
  callback = function()
		o.tabstop = 8
		o.shiftwidth = 8
    o.expandtab = false
  end,
})

autocmd("BufEnter", {
  pattern = { "term://*" },
  callback = function()
    o.wo.nonumber = true
    o.wo.laststatus = 0
  end
})

autocmd("BufNewFile", {
  pattern = { "*.sh", "*.py", "*.[ch]", "*.cc", "*.cpp", "*.hpp" },
  callback = function()
    local author = vim.fn.trim(vim.fn.system('git config user.name'))
    if author == '' then
      author = '[your name]'
    end
    local curdate = vim.fn.strftime('%Y')
    local copyright = string.format("Copyright © %s %s. All Rights Reserved.",
                                      curdate, author)
    local script_env = '#!/usr/bin/env'

    if vim.bo.filetype == 'sh' then
      vim.fn.setline(1, string.format("%s bash", script_env))
      vim.fn.append(vim.fn.line("."), "")
      vim.fn.append(vim.fn.line(".") + 1, "")
    elseif vim.bo.filetype == 'python' then
      vim.fn.setline(1, string.format("%s python", script_env))
      vim.fn.append(vim.fn.line("."),"")
      vim.fn.append(vim.fn.line(".") + 1, "")
    else
      vim.fn.setline(1, "/*")
      vim.fn.append(vim.fn.line("."), string.format(' * %s', copyright))
      vim.fn.append(vim.fn.line(".") + 1," */")
      vim.fn.append(vim.fn.line(".") + 2, "")
      vim.fn.append(vim.fn.line(".") + 3, "")
    end
    if vim.fn.expand("%:e") == 'c' then
      vim.fn.append(vim.fn.line(".") + 4, '#include <stdio.h>')
      vim.fn.append(vim.fn.line(".") + 5, "")
      vim.fn.append(vim.fn.line(".") + 6, "")
    end
    if vim.fn.expand("%:e") == 'h' then
      local _hh = vim.fn.toupper(
        vim.fn.substitute(vim.fn.expand("%:t"), "\\.h", "_h", ""))
      vim.fn.append(vim.fn.line(".") + 4, string.format("#ifndef __%s", _hh))
      vim.fn.append(vim.fn.line(".") + 5, string.format("#define __%s", _hh))
      vim.fn.append(vim.fn.line(".") + 6, "")
      vim.fn.append(vim.fn.line(".") + 7, "")
      vim.fn.append(vim.fn.line(".") + 8, "")
      vim.fn.append(vim.fn.line(".") + 9, "#endif")
    end
    if vim.fn.expand("%:e") == 'cpp' then
      vim.fn.append(vim.fn.line(".") + 4, "#include <iostream>")
      vim.fn.append(vim.fn.line(".") + 5, "using namespace std;")
      vim.fn.append(vim.fn.line(".") + 6, "")
      vim.fn.append(vim.fn.line(".") + 7, "")
    end
    if vim.fn.expand("%:e") == 'hpp' then
      vim.fn.append(vim.fn.line(".") + 4, "#pragma once")
      vim.fn.append(vim.fn.line(".") + 5, "")
      vim.fn.append(vim.fn.line(".") + 6, "")
    end
    -- move cursor to appreciate line
    local line_num = vim.fn.line('$')
    if vim.fn.expand("%:e") == 'h' then
      vim.fn.cursor(line_num - 2, 1)
    else
      vim.fn.cursor(line_num, 1)
    end
  end
})

autocmd("BufWritePost", {
  pattern = { "*.[ch]", "*.cc", "*.cpp", "*.hpp" },
  callback = function()
    local author = vim.fn.trim(vim.fn.system('git config user.name'))
    if author == '' then
      author = '[your name]'
    end
    local curdate = vim.fn.strftime('%Y')
    local crline = vim.fn.getline(2)
    local olddate_h = vim.fn.matchstr(crline, ' [0-9]\\{4}', 3)
    local olddate_t = vim.fn.matchstr(crline, '-[0-9]\\{4}', 3)
    local newdate_h = ' ' .. curdate
    local newdate_t = '-' .. curdate
    if vim.fn.match(crline, author) > 0 then
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
})
