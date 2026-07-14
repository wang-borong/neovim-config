local nvchad_lsp = require "nvchad.configs.lspconfig"

local function kotlin_lsp_cmd()
  if vim.fn.exepath "kotlin-lsp" ~= "" then
    return { "kotlin-lsp", "--stdio" }
  end

  return { "intellij-server", "--stdio" }
end

-- LSP server configurations
local servers = {
  clangd = {
    on_attach = function(client, bufnr)
      nvchad_lsp.on_attach(client, bufnr)

      if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,
    cmd = {
      "clangd",
      "--header-insertion=never",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--rename-file-limit=0",
      "--background-index",
      "--background-index-priority=low",
      "--clang-tidy",
    },
  },
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          typeCheckingMode = "standard",
        },
      },
    },
  },
  ruff = {},
  bashls = {},
  neocmake = {},
  asm_lsp = {},
  verible = {},
  texlab = {},
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        analyses = {
          fieldalignment = true,
          nilness = true,
          shadow = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },
  kotlin_lsp = {
    cmd = kotlin_lsp_cmd(),
    filetypes = { "kotlin" },
    root_markers = {
      "settings.gradle",
      "settings.gradle.kts",
      "pom.xml",
      "build.gradle",
      "build.gradle.kts",
      "workspace.json",
      ".git",
    },
  },
  jqls = {},
  jsonls = {},
  marksman = {},
  tinymist = {
    settings = {
      exportPdf = "never",
    },
  },
}

local function default_lsp_config()
  return {
    on_attach = nvchad_lsp.on_attach,
    on_init = nvchad_lsp.on_init,
    capabilities = nvchad_lsp.capabilities,
  }
end

local function merge_lsp_config(config)
  return vim.tbl_deep_extend("force", default_lsp_config(), config)
end

local function setup_lsp_server(lsp, config)
  if vim.lsp.config then
    vim.lsp.config(lsp, config)
    vim.lsp.enable(lsp)
    return
  end

  require("lspconfig")[lsp].setup(config)
end

local function setup_clangd(config)
  local ok_clangd_extensions, clangd_extensions = pcall(require, "clangd_extensions")

  if ok_clangd_extensions then
    clangd_extensions.setup {
      memory_usage = {
        border = "rounded",
      },
      symbol_info = {
        border = "rounded",
      },
    }
  end

  setup_lsp_server("clangd", config)
end

-- Setup LSP servers with default configuration
local function setup_lsp_servers()
  for lsp, config in pairs(servers) do
    local merged_config = merge_lsp_config(config)

    if lsp == "clangd" then
      setup_clangd(merged_config)
    else
      setup_lsp_server(lsp, merged_config)
    end
  end
end

setup_lsp_servers()
