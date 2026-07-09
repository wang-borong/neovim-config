local M = {}

M.treesitter = {
  ensure_installed = {
    "lua",
    "vim",
    "comment",
    "dockerfile",
    "json",
    "bash",
    "python",
    "cuda",
    "perl",
    "c",
    "cpp",
    "dart",
    "rust",
    "toml",
    "go",
    "verilog",
    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    "lua-language-server",
    "bash-language-server",
    "stylua",
    "shfmt",
    "shellcheck",
    "jq",
    "clang-format",
    "clangd",
    "codelldb",
    "debugpy",
    "gopls",
    "marksman",
    "prettier",
    "prettierd",
    "pyright",
    "ruff",
    "rust-analyzer",
    "verible",
    "java-language-server",
    "tinymist",
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
