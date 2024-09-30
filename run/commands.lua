local commands = {}
local args = {}

local function create_command(name)
  vim.api.nvim_create_user_command(name, commands[name], args[name])
end

local function command(name, cb, args_)
  commands[name] = cb
  args[name] = args_
end

local edit_subcommands = require'private'.hashset('add', 'rm')

command('Cargo', function(tbl)
  local subcommand = tbl.fargs[1]

  vim.cmd('!cargo ' .. tbl.args)

  if edit_subcommands[subcommand] then
    require'rustaceanvim.commands.workspace_refresh'()
  end
end, { nargs = '+' })
create_command('Cargo')

command('W', function (tbl)
  vim.cmd('w '..(tbl.args or ''))
end, {nargs = '*'})

for name in pairs(commands) do
  create_command(name)
end
