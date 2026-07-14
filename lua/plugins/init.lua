local overrides = require "configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      require "configs.lint"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "p00f/clangd_extensions.nvim",
    },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    init = function()
      require("configs.rustaceanvim").setup()
    end,
  },

  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapClearBreakpoints",
      "DapContinue",
      "DapDisconnect",
      "DapEval",
      "DapNew",
      "DapPause",
      "DapRestartFrame",
      "DapSetLogLevel",
      "DapShowLog",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapTerminate",
      "DapToggleBreakpoint",
      "DapToggleRepl",
      "STM32OpenOCD",
    },
    keys = require "configs.dap_keys",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require "configs.dap"
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls_config = require "configs.jdtls"

      jdtls_config.start()

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserJdtls", { clear = true }),
        pattern = "java",
        callback = jdtls_config.start,
      })
    end,
  },

  {
    "jedrzejboczar/nvim-dap-cortex-debug",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    keys = {
      {
        "<leader>dM",
        function()
          require("dap").continue()
        end,
        desc = "DAP: start STM32 cortex-debug",
      },
    },
    config = function()
      require("configs.cortex_debug").setup()
    end,
  },

  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    cmd = {
      "FlutterRun",
      "FlutterDevices",
      "FlutterEmulators",
      "FlutterReload",
      "FlutterRestart",
      "FlutterQuit",
      "FlutterOutlineToggle",
    },
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      ui = {
        border = "rounded",
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
      lsp = {
        color = {
          enabled = true,
        },
        settings = {
          completeFunctionCalls = true,
          showTodos = true,
          analysisExcludedFolders = {
            vim.fn.expand "$HOME/.pub-cache",
          },
        },
      },
    },
  },

  -- override plugin configs
  {
    "mason-org/mason.nvim",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup {}
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>ta", "<cmd>ZenMode<cr>", desc = "Toggle zen mode" },
    },
    opts = require "configs.zen",
  },

  {
    "dhananjaylatkar/cscope_maps.nvim",
    cmd = { "Cs", "Cscope", "Cstag", "CsPrompt", "CsStackView" },
    cond = function()
      return vim.fn.executable "cscope" == 1
    end,
    ft = { "c", "cpp", "cuda" },
    config = function()
      require "configs.cscope_maps"
    end,
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require "configs.gitsigns"
    end, -- Override to setup mason-lspconfig
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>ha",
        function()
          require("configs.harpoon").open_telescope()
        end,
        desc = "Open harpoon window",
      },
    },
    config = function()
      require("configs.harpoon").setup()
    end,
  },

  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    cmd = "SnipRun",
    config = function()
      require("sniprun").setup {}
    end,
  },

  {
    "h-hg/fcitx.nvim",
    event = "InsertEnter",
    -- ft = {
    --   "tex",
    --   "markdown",
    -- }
  },

  {
    "kaarmu/typst.vim",
    ft = "typst",
  },
}

return plugins
