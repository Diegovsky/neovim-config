local M = {}

--- Returns true if an executable named `bin` exists on the system
--- @param bin string
--- @return boolean
function M.executable(bin)
  return vim.fn.executable(bin) == 1
end

--- Merges two map tables and their list parts in order.
--- The first argument decides what to do if the same
--- key is found in multiple tables.
--- @param behaviour 'error'|'keep'|'force'
--- @vararg table
function M.tbl_join(behaviour, ...)
    local merged = vim.tbl_extend(behaviour, ...)
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

function M.debug(...)
  print(vim.inspect(...))
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
Priv = M
return M
