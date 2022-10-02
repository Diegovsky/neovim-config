local M = {}

CALL_ONCE = setmetatable({}, {
  __call = function (self, i)
    if self[i] == nil or self[i] == 'fail' then
      return true
    else
      return false
    end
  end
})

M.call_once = CALL_ONCE

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

function M.openTerm(cmd)
  local splits = require'private.splits'
  splits.split()
  vim.cmd('terminal '..(cmd or ""))
end

function M.nativeTerm(cmd, term)
  vim.cmd('!'..(term or 'alacritty')..' '..cmd)
end

function M.normpath(s)
  if s:sub(#s, #s) ~= "/" then
    return s .. "/"
  end
  return s
end

--- @param gvarname string
function M.try_run(gvarname)
  if CALL_ONCE(gvarname) then
    if CALL_ONCE[gvarname] == nil then
      CALL_ONCE[gvarname] = true
    end
    return true
  else
    return false
  end
end

function M.unrun(gvarname)
  local r = CALL_ONCE[gvarname]
  CALL_ONCE[gvarname] = 'fail'
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

function M.ensuretype(value, type_, name)
  name = name or "argument"
  if type(value) ~= type_ then
    error(("Expected `%s` to be `%s`, found %S"):format(name, type_, type(value)), 1)
  end
  return value
end

function M.ensurecallable(value, name)
  if type(value) == "function" then
    return value
  elseif type(value) == "table" and getmetatable(value).__call then
    return value
  else
    error(("Expected '%s' to be callable, got `%s` instead."):format(name, type(value)), 2)
  end
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
