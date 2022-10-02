local M = {
    is_bootstrapped = false,
}

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
function M.boostrap()
    local has_packer, _ = pcall(require, 'packer')
    if not has_packer then
        print("Packer is not installed. Cloning into packer.nvim ...")
        local output = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        if vim.v.shell_error ~= 0 then
            print(("Failed to boostrap packer (error %d)"):format(vim.v.shell_error or 0))
            print('Git output:\n'..output)
            return
        end
        vim.cmd [[packadd packer.nvim]]
        vim.cmd [[packloadall!]]
        M.is_bootstrapped = true
    end
end

function M.ensure_packer(use)
    if vim.fn.empty(vim.fn.glob(install_path)) == 0 then
       use'wbthomason/packer.nvim'
    end
    if M.is_bootstrapped then
        require'packer'.sync()
    end
end

function M.ensure_projection(use)
    local config = function ()
        require("projection").init {
            enable_sorting = true,
            should_title = true
        }
      end
    local projection_path = '~/Projects/projection.nvim'
    local fn = vim.fn
    if fn.empty(fn.glob(projection_path)) == 1 then
        use { 'Diegovsky/projection.nvim', config = config }
    else
        use { projection_path, as = 'projection-local', config = config }
    end
end

function M.prevent_init()
    if M.is_bootstrapped  then
       print("Initialization done.")
       os.exit(0)
    end
end

return M
