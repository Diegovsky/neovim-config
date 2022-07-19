local dbg = require("private").debug


local commands = {}
local args = {}

local function create_command(name)
  vim.api.nvim_create_user_command(name, commands[name], args[name])
end

local function command(name, cb, args_)
  commands[name] = cb
  args[name] = args_
end

command('Lua', function(tbl)
  local body = tbl.args
  local _, err = pcall(loadstring(("require'private'.debug(%s)"):format(body)))
  if err then
    print("Error executing expression: "..err)
  end
end,
{ complete = "lua", nargs = "+" })

command('LuaReload', function(tbl)
  local name = tbl.fargs[1]
  if package.loaded[name] then
    if name == 'private.lspcfg' then
      require'private.lspcfg'.reload()
    else
      package.loaded[name] = nil
    end
    return require(name)
  else
    print("Package " .. name .. " not present")
  end
end,
{
  nargs = "+",
  complete = function(lead)
    local packages = vim.tbl_keys(package.loaded)
    packages = vim.tbl_filter(function (el)
      return string.find(el, lead, nil, true)
    end, packages)
    return packages
  end,
})


require'private'.onft('rust', 'Add Cargo user command', function ()
  command('Cargo', function(tbl)
    print(tbl.args)
    vim.cmd('!cargo ' .. tbl.args)
    vim.cmd'RustReloadWorkspace'
  end, { nargs = '+' })
  create_command('Cargo')
end)

command('W', function (tbl)
  vim.cmd('w '..(tbl.args or ''))
end, {nargs = '*'})

command('LspSetup', function(tbl)
  require'private.lspcfg'.setup_server(tbl.fargs[1])
end, {nargs = '+'})

for name in pairs(commands) do
  create_command(name)
end
