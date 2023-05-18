--- @class Privatekeybindutils
local M = {}

local utils = require'private'

function M.prefix(prefix)
  return function(key)
    return prefix..key
  end
end

function M.fmt(template)
  return function(arg)
    return template:format(arg)
  end
end

function M.vimcmd(prefix)
  prefix = prefix or ""
  return function(val)
    return('<cmd>%s%s<cr>'):format(prefix, val)
  end
end

---@param func function(string?)
---@return function(string?)
function M.runfunc(func)
  return function(value)
    return function() func(value) end
  end
end

function M.noop(value)
  return value
end

--- @alias DeclarativeMapping string|fun(string?):string?

--- @param mode string|string[]
--- @param t table<string, DeclarativeMapping>
--- @param mapval (fun(value: string):(string|fun()))?
--- @param mapkey (fun(key: string):string)?
--- @param opts table|nil
function M.declmaps(mode, t, mapval, mapkey, opts)
  mapval = mapval or M.vimcmd()

  mapkey = mapkey or M.noop

  for key, value in pairs(t) do
    key = mapkey(key)
    if type(value) == "string" then
      value = mapval(value)
    end

    vim.keymap.set(mode, key, value, opts)
  end
end

--- @param mode string|string[]
--- @param t table<string, DeclarativeMapping>
function M.declremaps(mode, t)
  M.declmaps(mode, t, M.noop, M.noop, {remap=true})
end

--- Evaluates to `<expr>` if no lsp is attached or a fallback if it is.
function M.not_lsp(expr, fallback)
  return function ()
    local clients = vim.tbl_filter(function (client)
      return client.name ~= 'null-ls'
    end,vim.lsp.get_active_clients({bufnr=0}))

    if #clients == 0 and vim.fn.pumvisible() == 1 then
      return require'private'.t(expr)
    else
      return require'private'.t(fallback)
    end
  end
end

return M
