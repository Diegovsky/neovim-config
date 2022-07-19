-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/diegovsky/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/diegovsky/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/diegovsky/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/diegovsky/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/diegovsky/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  chadtree = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/chadtree",
    url = "https://github.com/ms-jpq/chadtree"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-snippy"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/cmp-snippy",
    url = "https://github.com/dcampos/cmp-snippy"
  },
  ["dhall-vim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/dhall-vim",
    url = "https://github.com/vmchale/dhall-vim"
  },
  ["dirbuf.nvim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/dirbuf.nvim",
    url = "https://github.com/elihunter173/dirbuf.nvim"
  },
  ["direnv.vim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/direnv.vim",
    url = "https://github.com/direnv/direnv.vim"
  },
  ["dressing.nvim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["feline.nvim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/feline.nvim",
    url = "https://github.com/feline-nvim/feline.nvim"
  },
  ["fidget.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vfidget\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["git-conflict.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17git-conflict\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/git-conflict.nvim",
    url = "https://github.com/akinsho/git-conflict.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["hotpot.nvim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/hotpot.nvim",
    url = "https://github.com/rktjmp/hotpot.nvim"
  },
  kommentary = {
    config = { "\27LJ\2\nN\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25use_default_mappings\22kommentary.config\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/kommentary",
    url = "https://github.com/b3nj5m1n/kommentary"
  },
  ["mini.nvim"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0+\2\0\0B\0\2\1K\0\1\0\nsetup\15mini.pairs\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/mini.nvim",
    url = "https://github.com/echasnovski/mini.nvim"
  },
  neogit = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogit\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  ["null-ls.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\6\0\v\0\0196\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0034\4\3\0009\5\6\0009\5\a\0059\5\b\5>\5\1\0049\5\6\0009\5\a\0059\5\t\5>\5\2\4=\4\n\3B\1\2\1K\0\1\0\fsources\nblack\vstylua\15formatting\rbuiltins\blog\1\0\0\1\0\2\nlevel\twarn\venable\1\nsetup\fnull-ls\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-jdtls"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-jdtls",
    url = "https://github.com/mfussenegger/nvim-jdtls"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-snippy"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-snippy",
    url = "https://github.com/dcampos/nvim-snippy"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n�\3\0\0\6\0\27\0\0316\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0005\4\t\0=\4\n\3=\3\v\0025\3\f\0=\3\r\0025\3\14\0=\3\15\0025\3\21\0005\4\16\0005\5\17\0=\5\18\0045\5\19\0=\5\20\4=\4\22\0035\4\23\0004\5\0\0=\5\24\4=\4\25\3=\3\26\2B\0\2\1K\0\1\0\16textobjects\vselect\fkeymaps\1\0\2\14lookahead\2\venable\2\tswap\1\0\0\18swap_previous\1\0\1\14<leader>A\21@parameter.inner\14swap_next\1\0\1\14<leader>a\21@parameter.inner\1\0\1\venable\2\14autopairs\1\0\1\venable\2\tyati\1\0\1\venable\2\vindent\fdisable\1\3\0\0\vpython\trust\1\0\1\venable\2\26incremental_selection\1\0\1\venable\2\14highlight\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    config = { "\27LJ\2\n`\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\roverride\1\0\1\fdefault\2\nsetup\22nvim-web-devicons\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["onedark.nvim"] = {
    config = { "\27LJ\2\nb\0\0\3\0\5\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\4\0B\0\1\1K\0\1\0\tload\1\0\1\nstyle\vdarker\nsetup\fonedark\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/onedark.nvim",
    url = "https://github.com/navarasu/onedark.nvim"
  },
  ["parinfer-rust"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/parinfer-rust",
    url = "https://github.com/eraserhd/parinfer-rust"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["projection-local"] = {
    config = { "\27LJ\2\n\\\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\19enable_sorting\2\17should_title\2\tinit\15projection\frequire8\1\0\5\0\3\0\t6\0\0\0003\2\1\0B\0\2\3\n\1\0\0X\2\3�6\2\2\0\18\4\1\0B\2\2\1K\0\1\0\nprint\0\npcall\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/projection-local",
    url = "/home/diegovsky/.config/nvim//plugins/projection.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/quick-scope",
    url = "https://github.com/unblevable/quick-scope"
  },
  ["rust-tools.nvim"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["symbols-outline.nvim"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/symbols-outline.nvim",
    url = "https://github.com/simrat39/symbols-outline.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    config = { "\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\14ui-select\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope-zoxide"] = {
    config = { "\27LJ\2\nK\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\vzoxide\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/telescope-zoxide",
    url = "https://github.com/jvgrootveld/telescope-zoxide"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n�\b\0\0\a\0'\0@6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\5\0005\3\3\0004\4\0\0=\4\4\3=\3\6\0025\3\b\0005\4\a\0=\4\t\0035\4\v\0005\5\n\0=\5\f\0045\5\r\0=\5\14\4=\4\15\0036\4\0\0'\6\16\0B\4\2\0029\4\17\4=\4\18\0035\4\19\0=\4\20\0036\4\0\0'\6\16\0B\4\2\0029\4\21\4=\4\22\0034\4\0\0=\4\23\0035\4\24\0=\4\25\0034\4\0\0=\4\26\0035\4\27\0=\4\28\0036\4\0\0'\6\29\0B\4\2\0029\4\30\0049\4\31\4=\4 \0036\4\0\0'\6\29\0B\4\2\0029\4!\0049\4\31\4=\4\"\0036\4\0\0'\6\29\0B\4\2\0029\4#\0049\4\31\4=\4$\0036\4\0\0'\6\29\0B\4\2\0029\4%\4=\4%\3=\3&\2B\0\2\1K\0\1\0\rdefaults\27buffer_previewer_maker\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\25telescope.previewers\fset_env\1\0\1\14COLORTERM\14truecolor\17path_display\16borderchars\1\t\0\0\b─\b│\b─\b│\b╭\b╮\b╯\b╰\vborder\19generic_sorter\29get_generic_fuzzy_sorter\25file_ignore_patterns\1\2\0\0\vbuild/\16file_sorter\19get_fuzzy_file\22telescope.sorters\18layout_config\rvertical\1\0\1\vmirror\1\15horizontal\1\0\0\1\0\1\vmirror\1\22vimgrep_arguments\1\0\n\20layout_strategy\15horizontal\21sorting_strategy\15descending\ruse_less\2\23selection_strategy\nreset\17initial_mode\vinsert\17entry_prefix\a  \20selection_caret\a> \18prompt_prefix\a> \19color_devicons\2\rwinblend\3\0\1\b\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\15extensions\1\0\0\14ui-select\1\0\0\nsetup\14telescope\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vala.vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/opt/vala.vim",
    url = "https://github.com/arrufat/vala.vim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-sensible"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/vim-sensible",
    url = "https://github.com/tpope/vim-sensible"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/vim-snippets",
    url = "https://github.com/honza/vim-snippets"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/home/diegovsky/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator",
    url = "https://github.com/christoomey/vim-tmux-navigator"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: telescope-zoxide
time([[Config for telescope-zoxide]], true)
try_loadstring("\27LJ\2\nK\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\vzoxide\19load_extension\14telescope\frequire\0", "config", "telescope-zoxide")
time([[Config for telescope-zoxide]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vfidget\frequire\0", "config", "fidget.nvim")
time([[Config for fidget.nvim]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\6\0\v\0\0196\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0034\4\3\0009\5\6\0009\5\a\0059\5\b\5>\5\1\0049\5\6\0009\5\a\0059\5\t\5>\5\2\4=\4\n\3B\1\2\1K\0\1\0\fsources\nblack\vstylua\15formatting\rbuiltins\blog\1\0\0\1\0\2\nlevel\twarn\venable\1\nsetup\fnull-ls\frequire\0", "config", "null-ls.nvim")
time([[Config for null-ls.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n�\b\0\0\a\0'\0@6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\5\0005\3\3\0004\4\0\0=\4\4\3=\3\6\0025\3\b\0005\4\a\0=\4\t\0035\4\v\0005\5\n\0=\5\f\0045\5\r\0=\5\14\4=\4\15\0036\4\0\0'\6\16\0B\4\2\0029\4\17\4=\4\18\0035\4\19\0=\4\20\0036\4\0\0'\6\16\0B\4\2\0029\4\21\4=\4\22\0034\4\0\0=\4\23\0035\4\24\0=\4\25\0034\4\0\0=\4\26\0035\4\27\0=\4\28\0036\4\0\0'\6\29\0B\4\2\0029\4\30\0049\4\31\4=\4 \0036\4\0\0'\6\29\0B\4\2\0029\4!\0049\4\31\4=\4\"\0036\4\0\0'\6\29\0B\4\2\0029\4#\0049\4\31\4=\4$\0036\4\0\0'\6\29\0B\4\2\0029\4%\4=\4%\3=\3&\2B\0\2\1K\0\1\0\rdefaults\27buffer_previewer_maker\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\25telescope.previewers\fset_env\1\0\1\14COLORTERM\14truecolor\17path_display\16borderchars\1\t\0\0\b─\b│\b─\b│\b╭\b╮\b╯\b╰\vborder\19generic_sorter\29get_generic_fuzzy_sorter\25file_ignore_patterns\1\2\0\0\vbuild/\16file_sorter\19get_fuzzy_file\22telescope.sorters\18layout_config\rvertical\1\0\1\vmirror\1\15horizontal\1\0\0\1\0\1\vmirror\1\22vimgrep_arguments\1\0\n\20layout_strategy\15horizontal\21sorting_strategy\15descending\ruse_less\2\23selection_strategy\nreset\17initial_mode\vinsert\17entry_prefix\a  \20selection_caret\a> \18prompt_prefix\a> \19color_devicons\2\rwinblend\3\0\1\b\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\15extensions\1\0\0\14ui-select\1\0\0\nsetup\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
try_loadstring("\27LJ\2\n`\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\roverride\1\0\1\fdefault\2\nsetup\22nvim-web-devicons\frequire\0", "config", "nvim-web-devicons")
time([[Config for nvim-web-devicons]], false)
-- Config for: git-conflict.nvim
time([[Config for git-conflict.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17git-conflict\frequire\0", "config", "git-conflict.nvim")
time([[Config for git-conflict.nvim]], false)
-- Config for: telescope-ui-select.nvim
time([[Config for telescope-ui-select.nvim]], true)
try_loadstring("\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\14ui-select\19load_extension\14telescope\frequire\0", "config", "telescope-ui-select.nvim")
time([[Config for telescope-ui-select.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: kommentary
time([[Config for kommentary]], true)
try_loadstring("\27LJ\2\nN\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25use_default_mappings\22kommentary.config\frequire\0", "config", "kommentary")
time([[Config for kommentary]], false)
-- Config for: onedark.nvim
time([[Config for onedark.nvim]], true)
try_loadstring("\27LJ\2\nb\0\0\3\0\5\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\4\0B\0\1\1K\0\1\0\tload\1\0\1\nstyle\vdarker\nsetup\fonedark\frequire\0", "config", "onedark.nvim")
time([[Config for onedark.nvim]], false)
-- Config for: projection-local
time([[Config for projection-local]], true)
try_loadstring("\27LJ\2\n\\\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\19enable_sorting\2\17should_title\2\tinit\15projection\frequire8\1\0\5\0\3\0\t6\0\0\0003\2\1\0B\0\2\3\n\1\0\0X\2\3�6\2\2\0\18\4\1\0B\2\2\1K\0\1\0\nprint\0\npcall\0", "config", "projection-local")
time([[Config for projection-local]], false)
-- Config for: mini.nvim
time([[Config for mini.nvim]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0+\2\0\0B\0\2\1K\0\1\0\nsetup\15mini.pairs\frequire\0", "config", "mini.nvim")
time([[Config for mini.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n�\3\0\0\6\0\27\0\0316\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0005\4\t\0=\4\n\3=\3\v\0025\3\f\0=\3\r\0025\3\14\0=\3\15\0025\3\21\0005\4\16\0005\5\17\0=\5\18\0045\5\19\0=\5\20\4=\4\22\0035\4\23\0004\5\0\0=\5\24\4=\4\25\3=\3\26\2B\0\2\1K\0\1\0\16textobjects\vselect\fkeymaps\1\0\2\14lookahead\2\venable\2\tswap\1\0\0\18swap_previous\1\0\1\14<leader>A\21@parameter.inner\14swap_next\1\0\1\14<leader>a\21@parameter.inner\1\0\1\venable\2\14autopairs\1\0\1\venable\2\tyati\1\0\1\venable\2\vindent\fdisable\1\3\0\0\vpython\trust\1\0\1\venable\2\26incremental_selection\1\0\1\venable\2\14highlight\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: neogit
time([[Config for neogit]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogit\frequire\0", "config", "neogit")
time([[Config for neogit]], false)
-- Config for: symbols-outline.nvim
time([[Config for symbols-outline.nvim]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "symbols-outline.nvim")
time([[Config for symbols-outline.nvim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType vala ++once lua require("packer.load")({'vala.vim'}, { ft = "vala" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/diegovsky/.local/share/nvim/site/pack/packer/opt/vala.vim/ftdetect/vala.vim]], true)
vim.cmd [[source /home/diegovsky/.local/share/nvim/site/pack/packer/opt/vala.vim/ftdetect/vala.vim]]
time([[Sourcing ftdetect script at: /home/diegovsky/.local/share/nvim/site/pack/packer/opt/vala.vim/ftdetect/vala.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
