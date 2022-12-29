--- @class Privkeybindutils
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

function M.noop()
  return M.prefix('')
end
--- @alias DeclarativeMapping string|fun(...)

--- @param mode string|string[]
--- @param t table<string, DeclarativeMapping>
--- @param mapval (fun(string):string)|nil
--- @param mapkey (fun(string):string)|nil
--- @param opts table<string, string>|nil
function M.declmaps(mode, t, mapval, mapkey, opts)
  mapval = mapval or M.vimcmd()

  mapkey = mapkey or function (key)
    return key
  end

  if opts ~= nil then
    opts = vim.tbl_extend('keep', opts or {}, {noremap=true})
  end

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
  M.declmaps(mode, t, M.noop(), M.noop(), {noremap=false})
end

--- @param filetype string|string[]
--- @param mode string|string[]
--- @param t table<string, DeclarativeMapping>
--- @param mapval fun(string):string
--- @param mapkey fun(string):string
--- @param opts table<string, string>
function M.ft_declmaps(filetype, mode, t, mapval, mapkey, opts)
  vim.api.nvim_create_autocmd(
    'FileType',
    {pattern=filetype,
    desc=("Set keybind on filetype '%s'"):format(vim.inspect(filetype)),
    callback=function ()
      M.declmaps(mode, t, mapval, mapkey, opts)
    end}
  )
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
