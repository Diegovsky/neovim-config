INIT_HAPPENED = false
-- Try to set language to english because I don't like to mix my language with
-- programming

pcall(vim.cmd, "language en_GB.utf8")

NVIM_CONFIG_FOLDER = NVIM_CONFIG_FOLDER or vim.fn.stdpath "config" .. "/"
NVIM_INIT_FILE = NVIM_CONFIG_FOLDER .. "/init.lua"

--- @type Priv
Priv = require'private'

local boostrap = require 'private.bootstrap'

dofile(NVIM_CONFIG_FOLDER .. '/config.lua')

vim.g.nvim_config_folder = NVIM_CONFIG_FOLDER
vim.g.nvim_init_file = NVIM_INIT_FILE
vim.g.asyncrun_open = 12


if not INIT_HAPPENED then
  boostrap.require_lazy().setup('plugins')
end

-- Bootstrap fennel support
-- require "hotpot"
-- Run .vim files before loading plugins
local scandir = require "plenary.scandir"


-- Run all lua files on run/
local luapath = require("plenary.path"):new(NVIM_CONFIG_FOLDER, "run")
scandir.scan_dir(tostring(luapath), {
  on_insert = function(file)
    local status, err = pcall(dofile, file)
    if not status and err ~= nil then
      print(('An error occoured while parsing a file: "%s"'):format(err))
    end
  end,
})

require'neodev'.setup()
require("private.lspcfg").init()

INIT_HAPPENED = true
