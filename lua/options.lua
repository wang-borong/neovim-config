require "nvchad.options"

local opt = vim.opt
local g = vim.g

-- Snippet paths configuration
local snippets_path = vim.fn.stdpath "config" .. "/snippets"
g.vscode_snippets_path = snippets_path
g.snipmate_snippets_path = snippets_path
g.lua_snippets_path = snippets_path

-- Basic editor options
opt.smartcase = true
opt.ignorecase = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.cursorline = true
opt.wrap = true
opt.mouse = ""
opt.iskeyword:append "-"

local option_group = vim.api.nvim_create_augroup("UserFiletypeOptions", { clear = true })

local function set_local(options)
  for name, value in pairs(options) do
    vim.opt_local[name] = value
  end
end

local filetype_options = {
  lua = { shiftwidth = 2, softtabstop = 2, tabstop = 2, expandtab = true },
  markdown = { shiftwidth = 2, softtabstop = 2, tabstop = 2, expandtab = true },
  tex = { shiftwidth = 2, softtabstop = 2, tabstop = 2, expandtab = true },
  typst = { shiftwidth = 2, softtabstop = 2, tabstop = 2, expandtab = true },
  python = { shiftwidth = 4, softtabstop = 4, tabstop = 4, expandtab = true, textwidth = 120 },
  rust = { shiftwidth = 4, softtabstop = 4, tabstop = 4, expandtab = true, textwidth = 100 },
  c = { shiftwidth = 8, softtabstop = 0, tabstop = 8, expandtab = false },
  cpp = { shiftwidth = 2, softtabstop = 2, tabstop = 2, expandtab = true },
  go = { shiftwidth = 4, softtabstop = 0, tabstop = 4, expandtab = false },
  kconfig = { softtabstop = 0, expandtab = false },
  make = { softtabstop = 0, expandtab = false },
  dts = { softtabstop = 0, expandtab = false },
}

for filetype, options in pairs(filetype_options) do
  local local_options = options
  vim.api.nvim_create_autocmd("FileType", {
    group = option_group,
    pattern = filetype,
    callback = function()
      set_local(local_options)
    end,
  })
end
