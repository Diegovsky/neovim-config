INIT_HAPPENED = false
-- Try to set language to english because I don't like to mix my language with
-- programming

pcall(vim.cmd, "language en_GB.utf8")

NVIM_CONFIG_FOLDER = NVIM_CONFIG_FOLDER or vim.fn.stdpath "config" .. "/"
NVIM_INIT_FILE = NVIM_CONFIG_FOLDER .. "/init.lua"

--- @type Private
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

require'neodev'.setup()

Priv.run_config()
require("private.lspcfg").init()

INIT_HAPPENED = true
