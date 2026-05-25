require "nvchad.options"

local opt = vim.opt
local o = vim.o
local g = vim.g
local autocmd = vim.api.nvim_create_autocmd

-- Snippet paths configuration
local snippets_path = vim.fn.stdpath "config" .. "/snippets"
g.vscode_snippets_path = snippets_path
g.snipmate_snippets_path = snippets_path
g.lua_snippets_path = snippets_path

-- Basic editor options
o.smartcase = true
o.ignorecase = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.autoindent = true
o.cursorline = true
o.wrap = true
o.mouse = ""

opt.iskeyword:append "-"

-- Helper function to create autocmd with pattern and callback
local function create_autocmd(events, pattern, callback)
  autocmd(events, {
    pattern = pattern,
    callback = callback,
  })
end

-- FileType-specific configurations
local filetype_configs = {
  {
    pattern = { "lua", "markdown", "tex" },
    callback = function()
      o.shiftwidth = 2
      o.tabstop = 2
    end,
  },
  {
    pattern = { "python" },
    callback = function()
      o.textwidth = 120
    end,
  },
  {
    pattern = { "rust" },
    callback = function()
      o.textwidth = 100
    end,
  },
  {
    pattern = { "kconfig", "make", "go", "dts" },
    callback = function()
      o.expandtab = false
    end,
  },
}

-- Buffer pattern-specific configurations
local buffer_configs = {
  {
    pattern = { "*.c", "*.h" },
    callback = function()
      o.tabstop = 8
      o.shiftwidth = 8
      o.expandtab = false
    end,
  },
  {
    pattern = { "*.cc", "*.cpp", "*.hh", "*.hpp" },
    callback = function()
      o.tabstop = 2
      o.shiftwidth = 2
    end,
  },
}

-- Apply FileType autocmds
for _, config in ipairs(filetype_configs) do
  create_autocmd({ "FileType" }, config.pattern, config.callback)
end

-- Apply buffer pattern autocmds
for _, config in ipairs(buffer_configs) do
  create_autocmd({ "BufEnter", "BufWinEnter" }, config.pattern, config.callback)
end
