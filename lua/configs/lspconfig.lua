
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { 'clangd', 'rust_analyzer', 'pyright',
                  'bashls','verible', 'texlab' }

-- lsps with default config
for _, lsp in ipairs(servers) do
  if lsp == "clangd" then
    lspconfig[lsp].setup {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--header-insertion=never",
        "-j", string.gsub(vim.fn.system('nproc'), "\n", ""),
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--rename-file-limit=0",
        "--background-index",
        "--background-index-priority=normal",
      },
    }
  else
    lspconfig[lsp].setup {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
  end
end

-- typescript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }
