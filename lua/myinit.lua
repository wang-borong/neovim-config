-- local autocmd = vim.api.nvim_create_autocmd
local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

opt.smartcase = true
opt.ignorecase = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.autoindent = true
opt.cursorline = true
opt.wrap = true
opt.mouse = ""

-- Gitsigns
vim.keymap.set('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
vim.keymap.set('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

autocmd("FileType", {
  pattern = { "lua", "markdown", "tex" },
  callback = function()
    opt.shiftwidth = 2
    opt.tabstop = 2
  end,
})

autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    opt.expandtab = true
		opt.textwidth = 120
  end,
})

autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.c", "*.h" },
  callback = function()
		opt.tabstop = 8
		opt.shiftwidth = 8
    opt.expandtab = false
  end,
})

require "others"
