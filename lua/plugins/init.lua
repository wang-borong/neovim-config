local overrides = require("configs.overrides")

---@type NvPluginSpec[]
local plugins = {

  "nvim-lua/plenary.nvim",

  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end
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
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
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
      require("better_escape").setup({})
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
      require("nvim-surround").setup({})
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      -- Telescope integration for harpoon
      local telescope_config = require("telescope.config").values
      local function open_harpoon_telescope()
        local harpoon_list = harpoon:list()
        local file_paths = {}
        
        for _, item in ipairs(harpoon_list.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = telescope_config.file_previewer({}),
          sorter = telescope_config.generic_sorter({}),
        }):find()
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
      require("sniprun").setup({})
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
