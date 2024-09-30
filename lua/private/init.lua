--- @class Private
local M = {}

function M.partial(fun, arg)
  return function(...)
    return fun(arg, ...)
  end
end

--- Runs all lua files on `run`/
function M.run_config()
  local scandir = require "plenary.scandir"
  local luapath = require("plenary.path"):new(NVIM_CONFIG_FOLDER, "run")
  scandir.scan_dir(tostring(luapath), {
    depth = 1,
    on_insert = function(file)
      local status, err = pcall(dofile, file)
      if not status and err ~= nil then
        print(('An error occoured while parsing a file: "%s"'):format(err))
      end
    end,
  })
end

---Returns the property located at `path` or nil. 
---@param obj table
---@param path string
---@return any|nil
function M.recget(obj, path)
  local curobj = obj
  for name in string.gmatch(path, '(%w+)%.?') do
    curobj = curobj[name]
    if curobj == nil then
      break
    end
  end
  return curobj
end

local hashset_meta =  {__index = function(self, key)
  return rawget(self, key) or false
end}

--- Creates a hashset with the elements of `...`
---@param ... any
---@return table
function M.hashset(...)
  local tbl = {}
  for _, val in ipairs({...}) do
    tbl[val] = true
  end
  return setmetatable(tbl, hashset_meta)
end

--- Returns true if an executable named `bin` exists on the system
--- @param bin string
--- @return boolean
function M.executable(bin)
  return vim.fn.executable(bin) == 1
end

function M.wipeHiddenBuffers()
    local buflist = vim.fn.getbufinfo({buflisted = 1})
    local count = 0
    local lastbuf
    for _, buf in pairs(buflist) do
      if #buf.windows == 0 and buf.changed == 0 and not string.find(buf.name, 'term://') then
        count = count + 1
        lastbuf = buf.name
        pcall(vim.api.nvim_buf_delete, buf.bufnr, {force=false})
      end
    end
    if count > 1 then
      print("Wiped "..count.." buffers")
    elseif count == 1 then
      print('Wiped '..lastbuf)
    else
      print('No buffers wiped')
    end
end

if _G['DEBUG'] then
  local f = assert(io.open("nvim-debug.log", 'w'), 'failed to open debug file')
  function M.debug(...)
    local args = {...}
    local len = select('#', ...)
    for i=1,len do
      if i >= 2 then
        f:write(i..': ')
      end
      local txt = vim.inspect(args[i])
      f:write(txt..'\n')
    end
    f:flush()
    return ...
  end
else
  function M.debug(...)
    -- do nothing
  end
end

return M
