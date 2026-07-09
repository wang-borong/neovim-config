local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_organize_imports", "ruff_format" },
    go = { "goimports", "gofumpt" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    cuda = { "clang_format" },
    rust = { "rustfmt" },
    java = { "google-java-format" },
    kotlin = { "ktlint" },
    dart = { "dart_format" },
    cmake = { "cmake_format" },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
    yml = { "prettierd", "prettier", stop_after_first = true },
  },

  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_format = "fallback",
  -- },
}

return options
