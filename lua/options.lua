require "nvchad.options"

local opt = vim.opt
local o = vim.o
local g = vim.g
local autocmd = vim.api.nvim_create_autocmd

-- vscode format i.e json files
g.vscode_snippets_path = vim.fn.stdpath "config" .. "/snippets"
-- snipmate format
g.snipmate_snippets_path = vim.fn.stdpath "config" .. "/snippets"
-- lua format
g.lua_snippets_path = vim.fn.stdpath "config" .. "/snippets"

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

opt.iskeyword:append("-")

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
