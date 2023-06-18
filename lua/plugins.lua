
local projection = function()
    local config = function ()
        require("projection").init {
            enable_sorting = false,
            should_title = true
        }
      end
    local projection_path = '~/Projects/projection.nvim'
    local fn = vim.fn
    if fn.empty(fn.glob(projection_path)) == 1 then
        return { 'Diegovsky/projection.nvim', config = config }
    else
        return { url=projection_path, config = config }
    end
end

return {
  -- Sensible vim defaults
  "tpope/vim-sensible",
  -- "tpope/vim-surround",

  -- hyprland config hl
  {'theRealCarneiro/hyprland-vim-syntax', ft='hypr'},

  {'kevinhwang91/nvim-ufo', config=function() require'ufo'.setup{
    provider_selector = function(bufnr, filetype, buftype)
      return {'treesitter', 'indent'}
    end
  } end,dependencies = 'kevinhwang91/promise-async'},


  -- Copilot for cooler autocompletion
  { "zbirenbaum/copilot-cmp", config=function ()
    require'copilot'.setup{
      suggestion = { enabled = false },
      panel = { enabled = false }
    }
    require'copilot_cmp'.setup()
  end, dependencies = "zbirenbaum/copilot.lua" },

  -- Fennel support
  -- "rktjmp/hotpot.nvim",
  -- Cool prompts for vim.ui
  "stevearc/dressing.nvim",
  -- Cool notifications
  { "rcarriga/nvim-notify" },
  'MunifTanjim/nui.nvim',

  --[[ { 'folke/noice.nvim', dependencies = {
    "MunifTanjim/nui.nvim",
  }, config = function() require('noice').setup(require'private.plugcfg.noice') end} ]]
  -- Git plugin
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    config = function() require("neogit").setup({}) end
  },

  -- Another git plugin
  {
    "akinsho/git-conflict.nvim",
---@diagnostic disable-next-line: missing-parameter
    config = function() require("git-conflict").setup() end
  },

  -- Lsp extensions for flutter
  { "akinsho/flutter-tools.nvim" },
  -- Lsp extensions for rust
  { "simrat39/rust-tools.nvim" },
  -- Lsp extensions for java
  "mfussenegger/nvim-jdtls",

  -- File manager
  "elihunter173/dirbuf.nvim",

  -- dhall support
  -- "vmchale/dhall-vim",

  "neovim/nvim-lspconfig",
  "onsails/lspkind.nvim",
  { "tamago324/nlsp-settings.nvim", lazy=false, config = function ()
    require'nlspsettings'.setup({
      config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
      local_settings_dir = ".nlsp-settings",
      local_settings_root_markers_fallback = { '.git' },
      append_default_schemas = true,
      loader = 'json'
    })
  end },

  { "williamboman/mason.nvim", config = function()
    require 'mason'.setup()
    require 'mason-lspconfig'.setup()
  end, dependencies = { 'williamboman/mason-lspconfig.nvim' } },

  { "nvim-tree/nvim-tree.lua", config = function ()
    require'nvim-tree'.setup({
      on_attach=function (bufnr)
        local api = require'nvim-tree.api'

        --- @param mode string
        ---@param rhs string
        local function delmap(mode, rhs)
          pcall(vim.keymap.del, mode, rhs, {buffer=bufnr})
        end

        -- Apply default nvim-tree mappings
        api.config.mappings.default_on_attach(bufnr)
        --- @param mode string
        ---@param rhs string
        ---@param lhs (string|function)
        ---@param desc string
        local function keymap(mode, rhs, lhs, desc)
          delmap(mode, rhs)
          vim.keymap.set(mode, rhs, lhs, {buffer=bufnr, remap=true, desc='nvim-tree: '..desc})
        end

        keymap('n', '<tab>', '<cr>', 'Open')
        keymap('n', '-', function() api.tree.change_root('..') end, 'Open Parent')
        keymap('n', '?', function() api.tree.toggle_help() end, 'Toggle Help')
        keymap('n', 'c', function() api.tree.change_root_to_node() end, 'Toggle Help')
      end
    })
  end },

  {
    "kyazdani42/nvim-web-devicons",
    -- Icon theme
    config = function() require("nvim-web-devicons").setup{
      override = {},
      default = true,
    } end},
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "dcampos/nvim-snippy",
      "dcampos/cmp-snippy",
      "honza/vim-snippets",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    run = "<cmd>TSUpdate",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function() require("nvim-treesitter.configs").setup(require 'private.plugcfg.treesitter') end
  },

  {
    -- Comment plugin settings
    "b3nj5m1n/kommentary",
    config = function()
      require("kommentary.config").use_default_mappings()
    end,
  },
  "unblevable/quick-scope",
  -- 'glepnir/dashboard-nvim',
  { "eraserhd/parinfer-rust", run = "cargo build --release" },
  "tpope/vim-fugitive",
  --[[{
    "noib3/nvim-compleet",
    config = function()
      require("compleet").setup()
    end,
    run = "cargo build --release && make install",
  }, ]]
  {
    "echasnovski/mini.nvim",
    lazy = false,
    config = require'private.plugcfg.mini',
  },
  { "folke/neodev.nvim", dependencies={ "neovim/nvim-lspconfig" }},
  { "feline-nvim/feline.nvim", dependencies = {
    "lewis6991/gitsigns.nvim",
  }, },
  -- Lsp outlines
  {
    "simrat39/symbols-outline.nvim",
    config = function() require('symbols-outline').setup() end
  },
  -- LSP Loading progress
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {}
    end,
  },
  { "arrufat/vala.vim", ft = "vala" },
  "nvim-lua/popup.nvim",
  { "nvim-lua/plenary.nvim", lazy = false },
  -- Telescope and Plugin
  {
    "nvim-telescope/telescope.nvim",
    config = function() require("telescope").setup(require 'private.plugcfg.telescope') end
  },
  {
    "jvgrootveld/telescope-zoxide",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "zoxide"
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },

  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup {
        style = "darker",
      }
      require("onedark").load()
    end,
  },
  --[[ if require 'private'.executable("silicon") then
    -- transforms code into images.
    { "NarutoXY/silicon.lua", config = function()
      require 'silicon'.setup(require 'private.plugcfg.silicon')
    end },
  end ]]
  "mfussenegger/nvim-dap",
  { "rcarriga/nvim-dap-ui", config = function()
    require 'dapui'.setup()
  end },
  "direnv/direnv.vim",
  { "christoomey/vim-tmux-navigator" },
  {
    "folke/trouble.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("trouble").setup {}
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null = require "null-ls"
      null.setup {
        log = {
          enable = false,
          level = "warn",
        },
        sources = {
          null.builtins.formatting.stylua, -- aur: stylua
          null.builtins.formatting.black, -- pacman: python-black
          -- null.builtins.formatting.rustfmt,
        },
      }
    end,
  },
  projection()
}
