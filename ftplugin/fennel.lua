vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.b.minipairs_disable = true
--[[
local function delmap(char)
    vim.keymap.set('i', char, char, {buffer=0})
end


local unmapkeys = [[()[]{}'"] ]
for i in string.gmatch(unmapkeys, '.') do
    delmap(i)
end ]]
