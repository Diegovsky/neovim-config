--- @class Privlogbuf
local M = {}

local bufname = 'LOGBUF'

function M.show(cmd)
  if vim.fn.bufwinnr(bufname) == -1 then
    M.makeLogBuffer()
  end
  if cmd then
    print(cmd)
    local bufnr = vim.fn.bufnr(bufname)
    vim.cmd(tostring(bufnr)..'read !'..cmd..' &')
  end
end

function M.hide()
    local bufnr = vim.fn.bufnr(bufname)
    vim.cmd(tostring(bufnr)..'hide')
end

function M.toggle()
  if vim.fn.bufwinnr(bufname) == -1 then
    M.show()
  else
    M.hide()
  end
end

function M.makeLogBuffer()
  vim.cmd('split '..bufname)
  vim.cmd('resize 6')
  vim.wo.winfixheight = true
  vim.bo.buftype = 'nofile'
  vim.bo.buflisted = false
end

return M
