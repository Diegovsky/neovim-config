
vim.wo.wrap = true
local galias = function (key)
  vim.keymap.set({'v', 'n'}, key, 'g'..key)
end
galias'j'
galias'k'
