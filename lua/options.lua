require "nvchad.options"

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

autocmd("BufNewFile", {
  pattern = { "*.sh", "*.py", "*.[ch]", "*.cc", "*.cpp", "*.hpp" },
  callback = function()
    require("helper").insert_header()
  end
})

autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.[ch]", "*.cc", "*.cpp", "*.hpp" },
  callback = function()
    require("helper").update_header()
  end
})
