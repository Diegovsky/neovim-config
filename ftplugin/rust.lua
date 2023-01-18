local pairs = require'mini.pairs'
local map = function (char, tbl)
  pairs.map_buf(0, 'i', char, tbl, {})
end

vim.keymap.set('i', "'", "'", {buffer=0})
map("<", { action = 'open', pair = "<>", neigh_pattern = '[%a:].', register = { cr = false } })
map(">", { action = 'close', pair = "<>", neigh_pattern = '[%a].', register = { cr = false } })
