local onft = function(ft, func)
    require'private'.onft(ft, 'Set options for '..ft, func)
end

onft('go', function ()
    vim.bo.softtabstop=false
    vim.bo.shiftwidth=8
end)

onft('markdown', function ()
    vim.wo.wrap = true
    local alias = function (key)
        vim.keymap.set({'v', 'n'}, key, 'g'..key)
    end
    alias'j'
    alias'k'
end)
