-- Load default LSP config if using new LSP API
if vim.lsp.config then
  require("nvchad.configs.lspconfig").defaults()
end

-- LSP server configurations
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
  gopls = {},
  jqls = {},
  marksman = {},
  tinymist = {
    settings = {
      exportPdf = "never",
    },
  },
}

-- Setup LSP servers with default configuration
local function setup_lsp_servers()
  if vim.lsp.config then
    -- New LSP API
    for lsp, config in pairs(servers) do
      vim.lsp.config(lsp, config)
      vim.lsp.enable(lsp)
    end
  else
    -- Legacy LSP API
    local lspconfig = require("lspconfig")
    local nvchad_lsp = require("nvchad.configs.lspconfig")
    
    local default_config = {
      on_attach = nvchad_lsp.on_attach,
      on_init = nvchad_lsp.on_init,
      capabilities = nvchad_lsp.capabilities,
    }
    
    for lsp, config in pairs(servers) do
      local merged_config = vim.tbl_deep_extend("force", default_config, config)
      lspconfig[lsp].setup(merged_config)
    end
  end
end

setup_lsp_servers()
