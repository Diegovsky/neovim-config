return [[
local dap_install = require'dap-install'
local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

dap_install.setup()

local askfor, cached = require'private'.askfor, require'private'.cached



local dap = require'dap'
local dapui = require'dapui'
local keybinds = {
  ["b"]  = dap.toggle_breakpoint,
  ["c"]  = dap.continue,
  ["so"] = dap.step_over,
  ["si"] = dap.step_into,
  ["o"]  = dapui.toggle,
}

require('dapui').setup()

-- DAP keybinds
local key_prefix = '<leader>d%s'
for key, func in pairs(keybinds) do
  require'private'.keymapf {
    combo = key_prefix:format(key);
    run = func
  }
end

-- DAP profiles
local configurations = {
    ['python'] = {
      {
        type = 'python',
        debugger = 'debugpy',
        request = 'launch',
        name = 'Launch python file',
        program = cached(askfor, {'Path to python file: '}),
      },
      {
        type = 'python';
        cwd = vim.fn.getcwd(),
        args = {'-k build_tree'},
        pythonArgs = {'--pdb'},
        request = 'launch',
        debugger = 'debugpy',
        name = 'Pyton :: Run pytest';
        program = 'pytest';
      }
    };
    ['ccppr_vsc'] = { {
        name = "Launch file";
        type = 'cpptools';
        MIMode = 'gdb';
        request = 'launch';
        program = cached(askfor, {'Path to exe:'});
        cwd = '${workspaceFolder}';
        env = {};
        args = function()
          local args = {}
          local i = 1
          while true do
            local arg = askfor{"Arg "..i..": ", type=''}
            if #arg == 0 then break end
            table.insert(args, arg)
            i = i + 1
          end
        end;
        stopOnEntry = true;
        }},
}

-- configurations.cpp = configurations.c
for adapter, conf in pairs(configurations) do
  dap_install.config(adapter,{ configurations = conf })
end
]]
