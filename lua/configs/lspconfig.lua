local lspconfig = require("lspconfig")

local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local defconf = {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

-- If on_attach, on_init and capabilities don't meet your needs,
-- You can override it here.
local servers = {
  clangd = {
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
  },
  rust_analyzer = {},
  pyright = {},
  bashls = {},
  verible = {},
  texlab = {},
  -- java_language_server = {
  --   cmd = {
  --     vim.fn.stdpath "data" .. "/mason/" ..
  --     "packages/java-language-server/dist/lang_server_linux.sh",
  --   },
  -- },
  gopls = {},
  jqls = {},
  marksman = {},
  tinymist = {
    settings = {
      exportPdf = "never",
      -- outputPath = "$root/target/$dir/$name",
    }
  }
}

-- lsps with default config
for lsp, optconf in pairs(servers) do
  local conf = vim.tbl_deep_extend("force", defconf, optconf)
  lspconfig[lsp].setup(conf)
end
