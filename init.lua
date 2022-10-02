-- Try to set language to english because I don't like to mix my language with
-- programming
vim.cmd "language en_GB.utf8"

NVIM_CONFIG_FOLDER = NVIM_CONFIG_FOLDER or vim.fn.stdpath "config" .. "/"
NVIM_INIT_FILE = NVIM_CONFIG_FOLDER .. "/init.lua"

local boostrap = require 'private.bootstrap'
boostrap.boostrap()

dofile(NVIM_CONFIG_FOLDER..'/config.lua')

vim.g.nvim_config_folder = NVIM_CONFIG_FOLDER
vim.g.nvim_init_file = NVIM_INIT_FILE
vim.g.asyncrun_open = 12

require("packer").startup(function(use)
  -- Sensible vim defaults
  use "tpope/vim-sensible"
  use {
    "tpope/vim-surround",
  }
  -- Fennel support
  use "rktjmp/hotpot.nvim"
  -- Cool prompts for vim.ui
  use { "stevearc/dressing.nvim" }
  -- Cool notifications
  use { "rcarriga/nvim-notify" }
  -- Git plugin
  use {
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup {}
    end,
  }

  -- Another git plugin
  use {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup()
    end,
  }

  -- Lsp extensions for rust
  use { "simrat39/rust-tools.nvim" }
  -- Lsp extensions for java
  use "mfussenegger/nvim-jdtls"

  -- File manager
  use "elihunter173/dirbuf.nvim"

  -- dhall support
  -- use "vmchale/dhall-vim"

  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use { "ms-jpq/chadtree", branch = "chad", run = "<cmd>CHADdeps" }
  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      -- Icon theme
      require("nvim-web-devicons").setup {
        override = {},
        default = true,
      }
    end,
  }
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "dcampos/nvim-snippy",
      "dcampos/cmp-snippy",
      "honza/vim-snippets",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
  }
  use {
    "nvim-treesitter/nvim-treesitter",
    run = "<cmd>TSUpdate",
    requires = {"nvim-treesitter/nvim-treesitter-textobjects"},
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
        },
        indent = {
          enable = true,
          disable = { "python", "rust" },
        },
        yati = { enable = true },
        autopairs = { enable = true },
        textobjects = {
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {},
          },
        }
      }
    end,
  }

  use {
    "b3nj5m1n/kommentary",
    config = function()
      -- Comment plugin settings
      require("kommentary.config").use_default_mappings()
    end,
  }
  use "unblevable/quick-scope"
  -- use 'glepnir/dashboard-nvim'
  use { "eraserhd/parinfer-rust", run = "cargo build --release" }
  use "tpope/vim-fugitive"
  --[[use {
    "noib3/nvim-compleet",
    config = function()
      require("compleet").setup()
    end,
    run = "cargo build --release && make install",
  } ]]
  use {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.pairs").setup(nil)
    end,
  }
  use { "feline-nvim/feline.nvim", requires = {
    "lewis6991/gitsigns.nvim",
  } }
  -- Lsp outlines
  use {
    "simrat39/symbols-outline.nvim",
    config = function()
      -- vim.g.symbols_outline = {}
    end,
  }
  -- LSP Loading progress
  use {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {}
    end,
  }
  use { "arrufat/vala.vim", ft = "vala" }
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  -- Telescope and Plugin
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {},
        },
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "> ",
          selection_caret = "> ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "descending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              mirror = false,
            },
            vertical = {
              mirror = false,
            },
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { "build/" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          use_less = true,
          path_display = {},
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        },
      }
    end,
  }
  use {
    "jvgrootveld/telescope-zoxide",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "zoxide"
    end,
  }
  use {
    "nvim-telescope/telescope-ui-select.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  }

  use {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup {
        style = "darker",
      }
      require("onedark").load()
    end,
  }
  -- use "Pocco81/DAPInstall.nvim"
  use "mfussenegger/nvim-dap"
  use "rcarriga/nvim-dap-ui"
  use "direnv/direnv.vim"
  use { "christoomey/vim-tmux-navigator" }
  use {
    "folke/trouble.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("trouble").setup {}
    end,
  }
  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
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
  }
  boostrap.ensure_projection(use)

  boostrap.ensure_packer(use)
end)

boostrap.prevent_init()

-- Bootstrap fennel support
require "hotpot"
-- Run .vim files before loading plugins
local scandir = require "plenary.scandir"


-- Run all lua files on run/
local luapath = require("plenary.path"):new(NVIM_CONFIG_FOLDER, "run")
scandir.scan_dir(tostring(luapath), {
  on_insert = function(file)
    local status, err = pcall(dofile, file)
    if not status and err ~= nil then
      print(('An error occoured while parsing a file: "%s"'):format(err))
    end
  end,
})

require("private.lspcfg").init()
