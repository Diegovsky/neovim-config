vim.fn.setenv('NVIM_CMD', "echo 'Failed to connect to nvim.\nQuitting.'; exit")
vim.fn.setenv('NVIM_LISTEN_ADDRESS', vim.v.servername)
vim.fn.setenv('GIT_EDITOR', 'nvr --servername ' .. vim.v.servername .. ' -cc split --remote-wait')

if not require'private'.try_run('CONFIG') then
    return
end
vim.g.mapleader = " "
vim.o.showmode = false
vim.o.laststatus = 3
vim.o.termguicolors = true
vim.o.linebreak = true

vim.o.synmaxcol=512
vim.o.omnifunc="syntaxcomplete#Complete"
vim.o.number=true
vim.o.relativenumber=true
vim.o.mouse="a"
vim.o.splitright=true
vim.o.splitbelow=true
vim.o.wrap=false
vim.o.guifont="FiraCode Nerd Font:h14"
vim.o.expandtab=true
vim.o.shiftwidth=4
vim.o.softtabstop=4
vim.o.compatible=false
vim.o.hidden=true
vim.o.encoding="utf-8"
vim.o.foldmethod="indent"
vim.o.foldenable=false
vim.o.foldlevelstart=99

-- global options
vim.g['vimsyn_embed'] = 'l'
vim.g['do_filetype_lua'] = 1
vim.g['did_load_filetypes'] = 0
vim.g['dashboard_default_executive'] = 'telescope'
vim.g['qs_highlight_on_keys'] = {'f', 'F', 't', 'T'}
vim.g['qs_buftype_blacklist'] = {'terminal', 'nofile'}
vim.g['conjure#filetype#scheme'] = 'conjure.client.guile.socket'
vim.g['tmux_navigator_no_mappings'] = 1
