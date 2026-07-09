local M = {}

local root_markers = {
  "build.gradle",
  "build.gradle.kts",
  "gradlew",
  "mvnw",
  "pom.xml",
  ".git",
}

function M.start()
  local jdtls = require "jdtls"
  local jdtls_setup = require "jdtls.setup"

  local root_dir = jdtls_setup.find_root(root_markers)
  if not root_dir then
    return
  end

  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = vim.fn.stdpath "data" .. "/jdtls-workspace/" .. project_name

  local bundles = {}
  local mason_share = vim.fn.stdpath "data" .. "/mason/share"
  local debug_bundle = vim.fn.glob(mason_share .. "/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar", true)

  if debug_bundle ~= "" then
    table.insert(bundles, debug_bundle)
  end

  local test_bundles = vim.split(vim.fn.glob(mason_share .. "/java-test/*.jar", true), "\n", { trimempty = true })
  for _, bundle in ipairs(test_bundles) do
    table.insert(bundles, bundle)
  end

  local config = {
    cmd = { "jdtls", "-data", workspace_dir },
    root_dir = root_dir,
    init_options = {
      bundles = bundles,
    },
    settings = {
      java = {
        configuration = {
          updateBuildConfiguration = "interactive",
        },
        format = {
          enabled = false,
        },
        inlayHints = {
          parameterNames = {
            enabled = "all",
          },
        },
        signatureHelp = {
          enabled = true,
        },
      },
    },
  }

  local ok_nvchad_lsp, nvchad_lsp = pcall(require, "nvchad.configs.lspconfig")
  if ok_nvchad_lsp then
    config.capabilities = nvchad_lsp.capabilities
    config.on_init = nvchad_lsp.on_init
    config.on_attach = function(client, bufnr)
      nvchad_lsp.on_attach(client, bufnr)

      if #bundles > 0 then
        jdtls.setup_dap { hotcodereplace = "auto" }
        jdtls.dap.setup_dap_main_class_configs()
      end

      local opts = { buffer = bufnr }
      vim.keymap.set(
        "n",
        "<leader>jo",
        jdtls.organize_imports,
        vim.tbl_extend("force", opts, { desc = "Java organize imports" })
      )
      vim.keymap.set(
        "n",
        "<leader>jt",
        jdtls.test_nearest_method,
        vim.tbl_extend("force", opts, { desc = "Java test nearest" })
      )
      vim.keymap.set("n", "<leader>jT", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Java test class" }))
    end
  end

  jdtls.start_or_attach(config)
end

return M
