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
    "cortex-debug",
    "debugpy",
    "delve",
    "gofumpt",
    "goimports",
    "golangci-lint",
    "google-java-format",
    "gopls",
    "asm-lsp",
    "basedpyright",
    "cmakelang",
    "neocmakelsp",
    "jdtls",
    "java-debug-adapter",
    "java-test",
    "kotlin-debug-adapter",
    "kotlin-lsp",
    "ktlint",
    "marksman",
    "prettier",
    "prettierd",
    "ruff",
    "verible",
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
