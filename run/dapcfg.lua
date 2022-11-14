local askfor, cached = require'private'.askfor, require'private'.cached

local dap = require'dap'
local dapui = require'dapui'
local kutils = require'private.keybindutils'
kutils.declmaps('n', {
  ["b"]  = dap.toggle_breakpoint,
  ["c"]  = dap.continue,
  ["so"] = dap.step_over,
  ["si"] = dap.step_into,
  ["o"]  = dapui.toggle,
}, nil, kutils.prefix('<leader>d'))

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
 dap.configurations[adapter] = conf
end
