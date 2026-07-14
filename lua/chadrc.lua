-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "github_dark",
  theme_toggle = { "github_dark", "one_light" },
  transparency = false,
  hl_override = require("highlights").override,
  hl_add = require("highlights").add,
}

M.mason = {
  pkgs = {
    "asm-lsp",
    "basedpyright",
    "bash-language-server",
    "clang-format",
    "clangd",
    "cmakelang",
    "codelldb",
    "cortex-debug",
    "debugpy",
    "delve",
    "gofumpt",
    "goimports",
    "golangci-lint",
    "google-java-format",
    "gopls",
    "java-debug-adapter",
    "java-test",
    "jdtls",
    "jq",
    "jq-lsp",
    "json-lsp",
    "kotlin-debug-adapter",
    "kotlin-lsp",
    "ktlint",
    "lua-language-server",
    "marksman",
    "neocmakelsp",
    "prettier",
    "prettierd",
    "ruff",
    "rust-analyzer",
    "shellcheck",
    "shfmt",
    "stylua",
    "texlab",
    "tinymist",
    "verible",
  },
}

return M
