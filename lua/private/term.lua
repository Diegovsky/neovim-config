--- @class Privterm
local M = {};

local terminals = {
  'footclient',
  'alacritty',
  'kgx',
  'gnome-terminal',
  'konsole',
  'xfce4-terminal',
  'x-terminal-emulator'
}

local termcache = nil

function M.open_term(cmd)
  local splits = require'private.splits'
  splits.split()
  vim.cmd('terminal '..(cmd or ""))
end

function M.native_term(cmd, term)
  term = term or termcache
  if term then
    if cmd then
      cmd = ' '..cmd
    else
      cmd = ''
    end
    vim.cmd('silent! !'..term..cmd..' &')
  else
    for _, v in ipairs(terminals) do
      if vim.fn.executable(v) then
        termcache = v
        return M.native_term(cmd, v)
      end
    end
    error("No terminal found")
  end
end

M.keymap = {
  main = '<leader>ot',
  sub = '<leader>oT',
}

M.action = {
  main = M.open_term,
  sub  = M.native_term,
}

function M.register_keybinds()
  vim.keymap.set('n', M.keymap.main, M.action.main)
  vim.keymap.set('n', M.keymap.sub, M.action.sub)
end

function M.swap()
  local temp = M.action.sub
  M.action.sub = M.action.main
  M.action.main = temp
  M.register_keybinds()
end

return M
