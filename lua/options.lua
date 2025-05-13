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

local autocmds = {
  [ { "FileType" } ] = { {
      pattern = { "lua", "markdown", "tex" },
      callback = function()
        o.shiftwidth = 2
        o.tabstop = 2
      end,
    }, {
      pattern = { "python" },
      callback = function()
        o.textwidth = 120
      end,
    }, {
      pattern = { "rust" },
      callback = function()
        o.textwidth = 100
      end
    }, {
      -- must use tabs in some filetypes
      pattern = { "kconfig", "make" },
      callback = function()
        o.expandtab = false
      end,
    }, {
      -- we perfer using tabs in some filetypes
      pattern = { "go", "dts" },
      callback = function()
        o.expandtab = false
      end
    }
  },
  [ { "BufEnter", "BufWinEnter" } ] = { {
      pattern = { "*.c", "*.h" },
      callback = function()
        o.tabstop = 8
        o.shiftwidth = 8
        o.expandtab = false
      end,
    },
  },
  [ { "BufEnter", "BufWinEnter" } ] = { {
      pattern = { "*.cc", "*.cpp", "*.hpp" },
      callback = function()
        o.tabstop = 2
        o.shiftwidth = 2
      end,
    },
  }
}

for k,vs in pairs(autocmds) do
  for _,v in ipairs(vs) do
    autocmd(k, v)
  end
end
