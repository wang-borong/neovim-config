local overrides = require "configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  "nvim-lua/plenary.nvim",

  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },

  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

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
    event = "VeryLazy",
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
    ft = { "c", "cpp", "cuda" },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local ok_cortex_debug, cortex_debug = pcall(require, "dap-cortex-debug")

      if not ok_cortex_debug then
        return
      end

      cortex_debug.setup {
        dap_vscode_filetypes = { "c", "cpp", "cuda" },
      }

      local function input_elf()
        return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "/build/", "file")
      end

      local function input_openocd_target()
        return vim.fn.input("OpenOCD target config: ", "target/stm32f4x.cfg", "file")
      end

      local cortex_openocd = cortex_debug.openocd_config {
        name = "STM32 ST-Link cortex-debug launch",
        cwd = "${workspaceFolder}",
        executable = input_elf,
        configFiles = function()
          return { "interface/stlink.cfg", input_openocd_target() }
        end,
        gdbTarget = "localhost:3333",
        rttConfig = cortex_debug.rtt_config(0),
        showDevDebugOutput = false,
      }

      local dap = require "dap"
      dap.configurations.c = dap.configurations.c or {}
      dap.configurations.cpp = dap.configurations.cpp or {}
      dap.configurations.cuda = dap.configurations.cuda or {}

      table.insert(dap.configurations.c, cortex_openocd)
      table.insert(dap.configurations.cpp, vim.deepcopy(cortex_openocd))
      table.insert(dap.configurations.cuda, vim.deepcopy(cortex_openocd))
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
    "williamboman/mason.nvim",
    opts = overrides.mason,
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
    "Pocco81/TrueZen.nvim",
    event = "VeryLazy",
    cmd = {
      "TZAtaraxis",
      "TZMinimalist",
      "TZFocus",
    },
    config = function()
      require "configs.truezen"
    end,
  },

  {
    "dhananjaylatkar/cscope_maps.nvim",
    dependencies = {
      "folke/which-key.nvim", -- optional [for whichkey hints]
      "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
      "ibhagwan/fzf-lua", -- optional [for picker="fzf-lua"]
      "nvim-tree/nvim-web-devicons", -- optional [for devicons in telescope or fzf]
    },
    event = "VeryLazy",
    opts = {
      -- USE EMPTY FOR DEFAULT OPTIONS
      -- DEFAULTS ARE LISTED BELOW
    },
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
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup {}

      -- Telescope integration for harpoon
      local telescope_config = require("telescope.config").values
      local function open_harpoon_telescope()
        local harpoon_list = harpoon:list()
        local file_paths = {}

        for _, item in ipairs(harpoon_list.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table {
              results = file_paths,
            },
            previewer = telescope_config.file_previewer {},
            sorter = telescope_config.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set("n", "<leader>ha", open_harpoon_telescope, { desc = "Open harpoon window" })
    end,
  },

  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    event = "VeryLazy",
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
    lazy = false,
  },
}

return plugins
