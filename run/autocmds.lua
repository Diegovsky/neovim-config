local onft = function(ft, func)
    require'private'.onft(ft, 'Set options for '..ft, func)
end

onft('go', function ()
    vim.bo.softtabstop=false
    vim.bo.shiftwidth=8
end)
onft('lua', function ()
   vim.bo.softtabstop=2
   vim.bo.shiftwidth=2
end)

onft('markdown', function ()
    vim.wo.wrap = true
    local galias = function (key)
        vim.keymap.set({'v', 'n'}, key, 'g'..key)
    end
    galias'j'
    galias'k'
end)

onft('rust', function ()
  local pairs = require'mini.pairs'
  local map = function (char, tbl)
    pairs.map_buf(0, 'i', char, tbl, {})
  end

  map("'", { action = 'closeopen', pair = "''", neigh_pattern = '[^<&\\][^>]', register = { cr = false } })
  map("<", { action = 'open', pair = "<>", neigh_pattern = '[%a].', register = { cr = false } })
  map(">", { action = 'close', pair = "<>", neigh_pattern = '[%a].', register = { cr = false } })
end)
