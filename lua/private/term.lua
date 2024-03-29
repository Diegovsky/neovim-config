--- @class Privateterm
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

M.termcache = nil

function M.open_term(cmd)
  vim.cmd('terminal '..(cmd or ""))
end

function M.get_native_term()
  if M.termcache then
    return M.termcache
  end
  for _, v in ipairs(terminals) do
    if vim.fn.executable(v) then
      M.termcache = v
      return M.termcache
    end
  end
  error("No terminal found")
end

local Job = require'plenary.job'

---Opens a terminal outside of neovim in the current directory
---@param cmd table?
---@param term string?
function M.native_term(cmd, term)
  term = term or M.get_native_term()
  if cmd then
    table.insert(cmd, 1, '-e')
  end
  Job:new{
    enable_handlers = false,
    enabled_recording = false,
    interactive = false,
    command = term,
    args = cmd,
  }:start()
end

M.keymap = {
  main = '<M-t>',
  sub = '<leader>T',
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
