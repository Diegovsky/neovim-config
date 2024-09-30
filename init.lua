-- Try to set language to english because I don't like to mix my language with
-- programming
---@diagnostic disable-next-line: param-type-mismatch
pcall(vim.cmd, "language en_GB.utf8")
NVIM_CONFIG_FOLDER = vim.fn.stdpath("config") .. "/"
-- Basic settings
dofile(NVIM_CONFIG_FOLDER .. '/config.lua')
DEBUG = os.getenv('DEBUG')
local boostrap = require 'private.bootstrap'
boostrap.bootstrap()

-- Run fennel code
require'fnl-init'
--- @type Private
Priv = require'private'
---@diagnostic disable-next-line: lowercase-global
dbg = require("private").debug
Priv.run_config()
require'neodev'.setup()
require("private.lspcfg").init()
