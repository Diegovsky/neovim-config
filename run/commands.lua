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

local function simplecmd(name, cb)
  command(name, cb, {
    nargs=0,
  })
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

local edit_subcommands = require'private'.hashset('add', 'rm')
local build_subcommands = require'private'.hashset('run', 'build')

command('Cargo', function(tbl)
  local subcommand = tbl.fargs[1]

  if build_subcommands[subcommand] then
    local cmd = table.concat({'cargo', unpack(tbl.fargs), ''}, ' ')
    cmd = cmd .. '; read'
    require'private.term'.native_term({'sh', '-c', cmd})
  else
    vim.cmd('!cargo ' .. tbl.args)
  end


  if edit_subcommands[subcommand] then
    -- Update the rust-analyzer workspace
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, 'RustReloadWorkspace')
  end
end, { nargs = '+' })
create_command('Cargo')

command('W', function (tbl)
  vim.cmd('w '..(tbl.args or ''))
end, {nargs = '*'})

command('LspSetup', function(tbl)
  if #tbl.fargs == 0 then
      vim.cmd[[LspStart]]
      return
  end
  require'private.lspcfg'.setup_server(tbl.fargs[1])
end, {nargs = '*'})

command('LspActivateProfile', function (tbl)
  local profile = tbl.fargs[1]
  require'private.lspcfg.profiles'.activate_profile(profile)
end, {nargs = 1, complete = function (lead)
    local profiles = vim.tbl_keys(require'private.lspcfg.profiles'.profiles)
    return vim.tbl_filter(function (el)
      return string.find(el, lead, nil, true)
    end, profiles)
end})

command('CodePrint', function()
  if package.loaded.silicon then
    require("silicon").visualise_api({to_clip = true, visible=true})
  else
    print("Silicon plugin is not installed :(")
  end
  end, {
    nargs=0,
    range=true,
  })

simplecmd('SwapTerm', require'private.term'.swap)

for name in pairs(commands) do
  create_command(name)
end
