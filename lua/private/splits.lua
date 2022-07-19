local M = setmetatable({}, {
  __index = function(self, key)
    if key == 'state' then
      return vim.g['diegovsky#^splithor'] or false
    else
      rawget(self, key)
    end
  end;
  __newindex = function (self, key, value)
    if key == 'state' then
      vim.g['diegovsky#^splithor'] = value
    else
      rawset(self, key, value)
    end
  end
})

function M.split(bufname)
  if vim.g['diegovsky#^splithor'] then
    vim.cmd('split')
  else
    vim.cmd('vsplit')
  end
  if bufname then
    vim.cmd('e '..bufname)
  end
end

return M
