local projection = function()
  local config = function()
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
    return { url = projection_path, config = config }
  end
end

local function silicon()
  if require 'private'.executable("silicon") then
    -- transforms code into images.
    return {
      "michaelrommel/nvim-silicon",
      lazy = true,
      cmd = "Silicon",
      opts = {
        to_clipboard = true,
        disable_defaults = true,
        language = function()
          return vim.bo.filetype
        end,
        output = function()
          return "./" .. os.date("!%Y-%m-%dT%H-%M-%S") .. "_code.png"
        end,
      },
    }
  else
    return {}
  end
end

return {
  {
    'kevinhwang91/nvim-ufo',
    config = function()
      require 'ufo'.setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      }
    end,
    dependencies = 'kevinhwang91/promise-async'
  },

  -- neovim profiling
  { "stevearc/profile.nvim", config = function ()
    local should_profile = os.getenv("NVIM_PROFILE")
    if should_profile then
      require("profile").instrument_autocmds()
      if should_profile:lower():match("^start") then
        require("profile").start("*")
      else
        require("profile").instrument("*")
      end
    end

    local function toggle_profile()
      local prof = require("profile")
      if prof.is_recording() then
        prof.stop()
        vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
          if filename then
            prof.export(filename)
            vim.notify(string.format("Wrote %s", filename))
          end
        end)
      else
        prof.start("*")
      end
    end
    vim.keymap.set("", "<f10>", toggle_profile)
  end },

  {"declancm/cinnamon.nvim", config=true},

  "mfussenegger/nvim-jdtls",

  -- Fennel support
  {"rktjmp/hotpot.nvim"},
  -- Cool prompts for vim.ui
  "stevearc/dressing.nvim",
  -- Cool notifications
  { "rcarriga/nvim-notify" },
  'MunifTanjim/nui.nvim',
  -- Git plugin
  {
    "NeogitOrg/neogit",
    dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "ibhagwan/fzf-lua"},
    config = true
  },

  -- Copilot for AI help
  { "zbirenbaum/copilot-cmp", config=function ()
    require'copilot'.setup{
      suggestion = { enabled = false },
      panel = { enabled = false }
    }
    require'copilot_cmp'.setup({event={'LspAttach'}})
    require'copilot.command'.disable()
  end, dependencies = "zbirenbaum/copilot.lua" },


  -- Git integration
  {"tpope/vim-fugitive", lazy=true, cmd={ 'Git', 'Gdiffsplit' }},

  -- Lsp extensions for flutter
  { "akinsho/flutter-tools.nvim" },
  -- Lsp extensions for rust
  {
    "mrcjkb/rustaceanvim",
    dependencies = { 'neovim/nvim-lspconfig' },
    filetypes = {'rust'},
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = require 'private.lspcfg'.on_attach,
          default_settings = {
            ['rust-analyzer'] = {

            }
          }
        }
      }
    end
  },

  -- File manager
  "elihunter173/dirbuf.nvim",
  "neovim/nvim-lspconfig",
  "onsails/lspkind.nvim",
  --[[ {
    "tamago324/nlsp-settings.nvim",
    lazy = false,
    opts = {
        config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
        local_settings_dir = ".nlsp-settings",
        local_settings_root_markers_fallback = { '.git' },
        append_default_schemas = true,
        loader = 'json'
      }
  }, ]]

  {
    "williamboman/mason.nvim",
    config = function()
      require 'mason'.setup()
      require 'mason-lspconfig'.setup()
    end,
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    lazy = false
  },

  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require 'nvim-tree'.setup({
        hijack_directories = { enable = false },
        on_attach = function(bufnr)
          local api = require 'nvim-tree.api'

          --- @param mode string
          ---@param rhs string
          local function delmap(mode, rhs)
            pcall(vim.keymap.del, mode, rhs, { buffer = bufnr })
          end

          -- Apply default nvim-tree mappings
          api.config.mappings.default_on_attach(bufnr)
          --- @param mode string
          ---@param rhs string
          ---@param lhs (string|function)
          ---@param desc string
          local function keymap(mode, rhs, lhs, desc)
            delmap(mode, rhs)
            vim.keymap.set(mode, rhs, lhs, { buffer = bufnr, remap = true, desc = 'nvim-tree: ' .. desc })
          end

          keymap('n', '<tab>', '<cr>', 'Toggle Open')
          keymap('n', '-', function() api.tree.change_root('..') end, 'Open Parent')
          keymap('n', '?', function() api.tree.toggle_help() end, 'Toggle Help')
          keymap('n', 'c', function() api.tree.change_root_to_node() end, 'Change root to...')
          keymap('n', 'U', function() api.tree.change_root(vim.fn.getcwd()) end, 'Cd into current dir')
        end
      })
    end
  },

  {
    "kyazdani42/nvim-web-devicons",
    -- Icon theme
    opts = {
        override = {},
        default = true,
      }
  },

  {
    "L3MON4D3/LuaSnip",
    -- update occasionally
    dependencies = { 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets', "honza/vim-snippets" },
    lazy = false,
    run = "make install_jsregexp",
    config = function()
      local ls = require'luasnip'
      if DEBUG then
          ls.log.set_loglevel("info")
      end
      require("luasnip.loaders.from_snipmate").lazy_load({
                exclude = {'all', '_'},
                fs_event_providers = {
                    libuv = true
                }
            })
      require("luasnip.loaders.from_vscode").lazy_load()
    end

  },
  -- cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
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
  -- 'glepnir/dashboard-nvim',
  { "eraserhd/parinfer-rust", build = "cargo build --release" },
  {
    "echasnovski/mini.nvim",
    lazy = false,
    config = require 'private.plugcfg.mini',
  },
  { "folke/neodev.nvim",      dependencies = { "neovim/nvim-lspconfig" } },
  {
    "feline-nvim/feline.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
  },
  -- Lsp outlines
  {
    "hedyhli/outline.nvim",
    config = true
  },
  -- LSP Loading progress
  {
    "j-hui/fidget.nvim",
    branch = "legacy",
    config = function()
      require("fidget").setup {}
    end,
  },
  { "arrufat/vala.vim",      ft = "vala" },
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
  "HiPhish/jinja.vim",
  silicon(),
  "mfussenegger/nvim-dap",
  "nvim-neotest/nvim-nio",
  {
    "rcarriga/nvim-dap-ui",
    requires = { "nvim-neotest/nvim-nio" },
    config = function()
      require 'dapui'.setup()
    end
  },
  "direnv/direnv.vim",
  {
    "folke/trouble.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("trouble").setup {
        auto_fold = true,
        severity = vim.diagnostic.severity.ERROR
      }
    end,
  },
  projection()
}
