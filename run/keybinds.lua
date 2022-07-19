local private = require'private'
local kutils = require'private.keybindutils'
local keymap = vim.keymap.set
local splits = require'private.splits'

keymap('t', '<esc>', '<C-\\><C-n>')

keymap({'n', 'v', 'o'}, 'qq', '%', {remap=true})
-- Rebinds
kutils.declmaps({ 'n', 'v' }, {
  ['<M-x>'] = ':e %:h/',
}, kutils.noop(), kutils.noop(), {remap=true})

---@diagnostic disable-next-line: missing-parameter
kutils.declmaps('n', {
  ['<leader>ot'] = 'silent !alacritty&';
  ['<leader>oT'] = private.openTerm;
  ['<leader>ol'] = require'private.logbuf'.toggle;
  ['<leader>os'] = 'SymbolsOutline';
  ['<M-i>'] =  function() splits.state = false end;
  ['<M-o>'] =  function() splits.state = true end;
  ['<M-n>'] = splits.split;
  ['<C-s>'] = 'write';
  ['<leader>hrr'] = 'luafile '..NVIM_INIT_FILE;
  ['<leader>hhr'] = function() package.loaded['private.lspcfg'] = nil; dofile(NVIM_INIT_FILE) end;
  ['<leader>hpi'] = 'PackerInstall';
  ['<leader>hpu'] = 'PackerUpdate';
  ['<C-space>']   = 'Telescope buffers';
  ['<leader>cd']  = 'Telescope zoxide list';
  ['<leader>of']  = 'Telescope oldfiles';
  ['<leader>fg'] = 'Telescope live_grep';
  ['<leader>tn'] = 'tabnew';
  ['<leader>tc'] = 'tabclose';
  ['<leader><leader>'] = function ()
    if vim.fn.getcwd() == vim.fn.getenv("HOME") then
      print("You can't do that, you're at ~!")
    else
      require'telescope.builtin'.find_files()
    end
  end;
  ['<M-h>'] = 'TmuxNavigateLeft';
  ['<M-j>'] = 'TmuxNavigateDown';
  ['<M-k>'] = 'TmuxNavigateUp';
  ['<M-l>'] = 'TmuxNavigateRight';
  ['<leader>oo'] = 'ChadOpen';
  ['<leader>bw'] = function()
    local buflist = vim.fn.getbufinfo({buflisted = 1})
    local c = 0
    local lastbuf
    for _, buf in pairs(buflist) do
      if #buf.windows == 0 and buf.changed == 0 then
        c = c + 1
        lastbuf = buf.name
        vim.api.nvim_buf_delete(buf.bufnr, {force=false})
      end
    end
    if c > 1 then
      print("Wiped "..c.." buffers")
    elseif c == 1 then
      print('Wiped '..lastbuf)
    else
      print('No buffers wiped')
    end
  end;
})

-- Remap <C-w><key> to <M-<key>>
do
  -- Set maps to be used with windows
  local function winCmd(key)
      keymap('n', ('<M-%s>'):format(key), ('<cmd>wincmd %s<cr>'):format(key), {})
  end

  local winkeys = 'wHJKLT|_=<>'
  for key in winkeys:gmatch('.') do
    winCmd(key)
  end
end

kutils.declmaps('n',
 {
  o = require'projection'.goto_project;
  a = require'projection'.add_project;
  d = require'projection'.remove_project;
 },
 nil,
 kutils.prefix"<leader>p"
)

do
  local gitcmd_prefix = "<leader>g"
  local gitcmds = {
    ['A'] = 'add -A';
    ['c'] = 'commit';
    ['ca'] = 'commit --amend';
    ['p'] = 'pull';
    ['u'] = 'push';
    ['a'] = 'add %';
    ['s'] = 'status';
  }
  kutils.declmaps(
    'n',
    gitcmds,
    kutils.vimcmd("Git "),
    kutils.prefix(gitcmd_prefix)
  )
end

-- Omnifunc mappings
if require'private'.try_run('omnifunc-bindings') then
  local opt = {expr=true, silent=true}
  local keymap = function(key, expr) keymap("i", key, kutils.not_lsp(expr, key), opt) end
  keymap("<C-Space>", "<C-x><C-o>")
  keymap("<Tab>", "<C-N>")
  keymap("<S-Tab>", "<C-P>")
end

-- Add copy and pasting like common GUIs.
kutils.declmaps({'n', 'v'}, {
  y = 'y';
  Y = 'Y';
  P = 'P';
  p = 'p';
}, kutils.prefix('"+'), kutils.fmt("<M-%s>"))

kutils.declmaps('i', {
  v = '"+p';
  V = '"+P';
  p = 'p';
  P = 'P';
}, kutils.fmt('<cmd>norm h%sll<cr>'), kutils.fmt("<C-%s>"))
