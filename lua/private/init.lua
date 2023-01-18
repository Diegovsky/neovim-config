--- @class Priv
--- @field bootstrap Privbootstrap
--- @field keybindutils Privkeybindutils
--- @field logbuf Privlogbuf
--- @field splits Privsplits
--- @field term Privterm
--- @field lspcfg Privlspcfg 
local M = {}

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
      if #buf.windows == 0 and buf.changed == 0 then
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

local extend = vim.tbl_deep_extend
--- Merges two map tables and their list parts in order.
--- The first argument decides what to do if the same
--- key is found in multiple tables.
--- @param behaviour 'error'|'keep'|'force'
--- @vararg table
function M.tbl_join(behaviour, ...)
    local merged = extend(behaviour, ...)
    local args = {...}
    local size = select('#', ...)
    for i = 1, size do
        for _, v in ipairs(args[i]) do
            merged[#merged+1] = v
        end
    end
    return merged
end

CALL_ONCE = setmetatable({}, {
  --- Returns `true` if function has not ran yet,
  --- `false` if function has ran
  __call = function (self, i)
    if self[i] ~= 'ran' then
      return true
    else
      self[i] = 'ran'
      return false
    end
  end
})

M.run_once = CALL_ONCE
M.try_run = M.run_once

function M.unrun(gvarname)
  local r = CALL_ONCE[gvarname]
  CALL_ONCE[gvarname] = 'cancelled'
  return r
end

--- @param f function
function M.cached(f, ...)
  local value = nil
  local args = { ... }
  return function()
    if value == nil then
      value = f(unpack(args))
    end
    return value
  end
end

local chars = {}
-- A..Z
for i = 0, 25 do
  table.insert(chars, string.char(65 + i))
end
-- a..z
for i = 0, 25 do
  table.insert(chars, string.char(97 + i))
end
-- 0..10
for i = 0, 9 do
  table.insert(chars, string.char(48 + i))
end

function M.randomstring(a, b)
  local min
  local max
  if b then
    min = a
    max = b
  else
    min = 1
    max = a
  end

  if min > max then
    error "Expected max to be greater than min"
  elseif min <= 0 then
    error "Min must be positive"
  elseif max <= 0 then
    error "Max must be positive"
  end
  local buf = ""
  for _ = 0, math.random(min, max) do
    buf = buf .. chars[math.random(#chars)]
  end
  return buf
end

function M.randomboolean(chance)
  chance = chance or 0.5
  return math.random() <= chance
end

local f = io.output()
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
  --f:close()
  return ...
end


function M.onft(ft, desc, func, ...)
  local args = {...}
  vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = ft,
    desc = desc or 'private.onft callback',
    callback = function ()
      func(unpack(args))
    end
  })
end

function M.t(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

function string.startswith(text, text2)
  return string.sub(text, 1, #text2) == text2
end

function M.insertlazy(prefix, tbl)
  return setmetatable(tbl, {
    __index = function(self, key)
      local suc, mod = pcall(require, prefix..'.'..key)
      if suc then
        return mod
      else
        return rawget(self, key)
      end
    end
  })
end

return M.insertlazy('private', M)
