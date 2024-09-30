--- @class Privatebootstrap
local M = {}

local lazy_path = vim.fn.stdpath("data") .. "/lazy/"
-- Ensure lazy and hotpot are always installed
function M.ensure_installed(plugin, branch)
  local user, repo = string.match(plugin, "(.+)/(.+)")
  local repo_path = lazy_path .. repo
  if not (vim.uv or vim.loop).fs_stat(repo_path) then
    vim.notify("Installing " .. plugin .. " " .. branch)
    local repo_url = "https://github.com/" .. plugin .. ".git"
    local out = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=" .. branch,
      repo_url,
      repo_path
    })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone " .. plugin .. ":\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  return repo_path
end

function M.bootstrap()
    local lazy_plugin = M.ensure_installed("folke/lazy.nvim", "stable")
    local hotpot_plugin = M.ensure_installed("rktjmp/hotpot.nvim", "v0.14.6")
    vim.opt.rtp:prepend({lazy_plugin, hotpot_plugin})
    vim.loader.enable()

    require'hotpot'.setup{
        enable_hotpot_diagnostics = true,
        compiler = {
            modules = {
                correlate = true
            }
        }
    }

    require'lazy'.setup('plugins')
end


return M
