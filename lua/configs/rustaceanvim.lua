local M = {}

function M.setup()
  local server = {
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        check = {
          command = "clippy",
        },
        inlayHints = {
          bindingModeHints = {
            enable = true,
          },
          closureReturnTypeHints = {
            enable = "with_block",
          },
          discriminantHints = {
            enable = "fieldless",
          },
          lifetimeElisionHints = {
            enable = "skip_trivial",
            useParameterNames = true,
          },
          typeHints = {
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
        },
      },
    },
  }

  local ok_nvchad_lsp, nvchad_lsp = pcall(require, "nvchad.configs.lspconfig")
  if ok_nvchad_lsp then
    server.on_attach = nvchad_lsp.on_attach
    server.on_init = nvchad_lsp.on_init
    server.capabilities = nvchad_lsp.capabilities
  end

  vim.g.rustaceanvim = {
    server = server,
    tools = {
      float_win_config = {
        border = "rounded",
      },
    },
  }
end

return M
