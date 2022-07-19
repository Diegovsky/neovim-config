local onft = require'private'.onft

onft('go', 'Set options for go', function ()
    vim.bo.softtabstop=false
    vim.bo.shiftwidth=8
end)
