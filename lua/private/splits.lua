--- @class Privsplits
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

local splitstates = {}
function M.togglesplit(bufname, on_window)
    local winnr = splitstates[bufname]
    if winnr then
        if vim.api.nvim_win_is_valid(winnr) then
            vim.api.nvim_win_close(winnr, true)
            splitstates[bufname] = nil
            return
        end
        splitstates[bufname] = nil
    end
    require'private.splits'.split(bufname)
    winnr = vim.fn.win_getid(vim.fn.winnr())
    on_window(winnr)
    splitstates[bufname] = winnr
end

return M
