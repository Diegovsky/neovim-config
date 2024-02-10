local kutils = require 'private.keybindutils'
local keymap = vim.keymap.set

require 'private.term'.register_keybinds()

-- Easily create a file in the current file's dir
keymap('n', '<M-x>', function()
  return ':edit ' .. vim.fn.expand("%:h") .. '/'
end, { expr = true })

kutils.declmaps('n', {
  ['<leader>os']       = 'SymbolsOutline',
  ['<M-i>']            = 'vsplit',
  ['<M-o>']            = 'split',
  ['<M-n>']            = function()
    print('You removed that, remember?')
  end,
  ['<leader>x']        = function() require 'telescope.builtin'.find_files { cwd = vim.fn.expand '%:h' } end,
  ['<C-s>']            = 'write',
  ['<C-a>']            = 'norm gg"+yG``',
  ['<leader>hrr']      = Priv.run_config,
  ['<leader>hhr']      = function()
    local prefix = 'private.'
    for pkg, _ in pairs(package.loaded) do
      if string.sub(pkg, 1, #prefix) == prefix then
        package.loaded[pkg] = nil
      end
      package.loaded['private'] = nil
    end
    dofile(NVIM_INIT_FILE)
  end,
  ['<leader>hpi']      = 'PackerInstall',
  ['<leader>hpu']      = 'PackerUpdate',
  ['<C-space>']        = 'Telescope buffers',
  ['<leader>cd']       = 'Telescope zoxide list',
  ['<leader>of']       = 'Telescope oldfiles',
  ['<leader>rg']       = 'Telescope live_grep',
  ['<leader>fg']       = 'Telescope live_grep',
  ['<leader>fs']       = 'Telescope lsp_dynamic_workspace_symbols',
  ['<leader>tn']       = 'tabedit %',
  ['<leader>tc']       = 'tabclose',
  ['<leader><leader>'] = function()
    if vim.fn.getcwd() == vim.fn.getenv("HOME") then
      print("You can't do that, you're at ~!")
    else
      require 'telescope.builtin'.find_files()
    end
  end,
  ['<leader>we']       = 'TroubleToggle workspace_diagnostics',
  ['<M-h>']            = 'TmuxNavigateLeft',
  ['<M-j>']            = 'TmuxNavigateDown',
  ['<M-k>']            = 'TmuxNavigateUp',
  ['<M-l>']            = 'TmuxNavigateRight',
  ['<leader>oo']       = 'NvimTreeToggle',
  -- Wipe buffers
  ['<leader>bw']       = require 'private'.wipeHiddenBuffers,
})

-- Remap <C-w><key> to <M-<key>>
do
  local winkeys = 'wHJKLT|_=<>'
  for key in winkeys:gmatch('.') do
    keymap('n', ('<M-%s>'):format(key), ('<cmd>wincmd %s<cr>'):format(key), {})
  end
end

if Priv.package_exists('noice.lsp') then
  local function scroll(key, offset)
    if not require("noice.lsp").scroll(offset) then
      return key
    end
  end

  local function mapscroll(key, offset)
    key = ('<C-%s>'):format(key)
    keymap('n', key, function() scroll(key, offset) end, { silent = true, expr = true })
  end

  mapscroll('u', 4)
  mapscroll('d', -4)
end

kutils.declmaps('n',
  {
    o = require 'projection'.goto_project,
    a = require 'projection'.add_project,
    d = require 'projection'.remove_project,
  },
  nil,
  kutils.prefix "<leader>p"
)

kutils.declmaps(
  'n',
  {
    ['A'] = 'add -A',
    ['c'] = 'commit',
    ['ca'] = 'commit --amend',
    ['p'] = 'pull',
    ['u'] = 'push',
    ['a'] = 'add %',
    ['s'] = 'status',
  },
  kutils.vimcmd("Git "),
  kutils.prefix("<leader>g")
)

-- Add copy and pasting like common GUIs.
kutils.declmaps({ 'n', 'v' }, {
  y = 'y',
  Y = 'Y',
  P = 'P',
  p = 'p',
}, kutils.prefix('"+'), kutils.fmt("<M-%s>"))

-- allow to quit terminal mode using ESC
keymap('t', '<esc>', '<C-\\><C-n>')
-- use qq as a bracket navigator
keymap({ 'n', 'v', 'o' }, 'qq', '%', { remap = true })

-- Remap line shift commands to more sane behaviours
kutils.declremaps('v', {
  ['<'] = '<gv',
  ['>'] = '>gv',
})

kutils.declremaps('n', {
  ['<'] = '<<',
  ['>'] = '>>',
})

-- Remap these chars so I can go to then more easily
for char in string.gmatch('(){}[]', '.') do
  keymap('n', char, 'f' .. char, {})
end

-- Add underscore aware word movements
local undmove = function(key)
  local oldopt = vim.o.iskeyword
  vim.opt.iskeyword:remove { "_" }
  vim.cmd('norm ' .. key)
  vim.o.iskeyword = oldopt
end

kutils.declmaps({ 'n', 'v', 'o' }, {
  w = 'w',
  b = 'b',
}, kutils.runfunc(undmove), kutils.prefix("<leader>"))
