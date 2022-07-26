local M = {}

local function log(...)
  if DEBUG then
    require'private'.debug(...)
  end
end

M.default_profiles = {
  vala_ls = {
    cmd = { "/usr/bin/vala-language-server" },
  },
  dartls = {
    cmd = {
      "/opt/flutter/bin/dart",
      "/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot",
      "--protocol=lsp",
    },
  },
  sumneko_lua = {
    cmd = { "/usr/bin/lua-language-server" },
    Lua = {
      runtime = { version = "Lua54" },
    },
  },
}

M.get_current_profile_name = function()
  -- Get attached clients to current buffer
  local clients = vim.lsp.buf_get_clients(0)
  for _, client in ipairs(clients) do
    -- Returns the first profile name found for any client
    local profile = M.active_profiles[client.name]
    if profile then
      return profile.name
    end
  end
end

M.active_profiles = {}

M.activate_profile = function(name)
  local profile = M.profiles[name]

  log('Trying to enable lsp profile '..name)

  if profile == nil then
    print("Profile "..name.." does not exist!")
    return
  end
  if M.active_profiles[profile.server_name] == profile then
    -- Profile already active
    log('Profile already active')
    return
  end
  M.active_profiles[profile.server_name] = profile
  log('Profile '..name..' enabled')
  require'private.lspcfg'.setup_server(profile.server_name)
end

M.profiles = {}

local function create_profile(name, server_name, getargs)
  --- @class Profile
  --- @field name string
  --- @field server_name string
  --- @field getargs function()
  --- Profile prototype
  local profile = {
    name = name,
    server_name = server_name,
    getargs = function ()
      return vim.tbl_deep_extend('force', M.default_profiles[server_name], getargs())
    end,
    setup = function()
      M.activate_profile(name)
    end
  }
  if M.profiles[name] then
    error("Profile "..name.." already exists!")
    return
  end
  M.profiles[name] = profile
end

function M.apply_profile(lspserver, args)
  local profile = M.active_profiles[lspserver]
  -- If there is an active profile, apply its args
  if profile then
     local profile_args = profile.getargs()
     args = vim.tbl_deep_extend("force", args, profile_args)
  end
  return args
end

--- Profiles

create_profile('sumneko_nvim', 'sumneko_lua', function()
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  return {
    -- cmd = {sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim', "DEBUG"},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
end)

return M
