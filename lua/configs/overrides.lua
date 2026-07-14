local M = {}

M.treesitter = {
  ensure_installed = {
    "lua",
    "vim",
    "comment",
    "dockerfile",
    "json",
    "cmake",
    "make",
    "bash",
    "python",
    "cuda",
    "asm",
    "perl",
    "c",
    "cpp",
    "dart",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "java",
    "kotlin",
    "rust",
    "ron",
    "toml",
    "verilog",
    "markdown",
    "markdown_inline",
    "typst",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
