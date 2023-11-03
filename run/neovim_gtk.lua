-- Don't run if not in neovim-gtk
if not vim.g.GtkGuiLoaded then
  return
end

--- Utility function to talk with neovim-gtk
local function rpc(...)
  vim.fn.rpcnotify(1, 'Gui', ...)
end

local function guicmd(...)
  rpc('Command', ...)
end

local function toggle_sidebar()
  guicmd('ToggleSidebar')
end

local function show_project_view()
  guicmd('ShowProjectView')
end

rpc('Font', string.gsub(vim.o.guifont, ':h', ' '))

require'private.keybindutils'.declmaps('n', {
  ['<leader>oO'] = toggle_sidebar;
  ['<leader>op'] = show_project_view;
})

