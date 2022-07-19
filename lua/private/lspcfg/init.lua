local lspconfig = require "lspconfig"
local M = {}
vim.o.completeopt = "menuone,noselect"

-- [[
-- !TODO: Make an OOP API
-- !TODO: find a better place to put cmp init
-- ]]

M.servers = {
  "clangd",
  "dartls",
  "emmet_ls",
  "gopls",
  "hls",
  "lemminx", -- xml server
  "pyright",
  "rust_analyzer",
  "solargraph",
  "sumneko_lua",
  "teal_ls",
  "vala_ls",
  "zls",
}

--- @param name string
--- @param opt table|nil
function M.setup_server(name, opt)
  local args = {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
  local profile = require 'private.lspcfg.profiles'.active_profiles[name]
  local profile_args
  if profile then
     profile_args = profile.getargs()
  end
  args = vim.tbl_deep_extend("force", args, profile_args or {}, opt or {})
  if name == "rust_analyzer" then
    require("rust-tools").setup { server = args }
  elseif name == 'jdtls' then
    require'jdtls'.start_or_attach(args)
  else
    lspconfig[name].setup(args)
  end
end


---@diagnostic disable-next-line: unused-local
M.on_attach = function(_client, bufnr)
  if bufnr == nil then
    bufnr = vim.api.nvim_get_current_buf()
  end

  local opts = { noremap = true, silent = true, buffer = bufnr }
  require'private.lspcfg.cmp'.cmp_init()

  require("private.keybindutils").declmaps("n", {
    ["gD"] = vim.lsp.buf.declaration,
    ["gd"] = vim.lsp.buf.definition,
    ["gi"] = vim.lsp.buf.implementation,
    ["gr"] = vim.lsp.buf.references,
    ["<leader>gt"] = vim.lsp.buf.type_definition,
    ["K"] = vim.lsp.buf.hover,
    ["<C-k>"] = vim.lsp.buf.signature_help,
    ["<leader>pl"] = function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    ["<leader>D"] = vim.lsp.buf.type_definition,
    ["<leader>rn"] = vim.lsp.buf.rename,
    ["<leader>ca"] = vim.lsp.buf.code_action,
    ["<leader>e"] = vim.diagnostic.open_float,
    ["[d"] = vim.diagnostic.goto_prev,
    ["]d"] = vim.diagnostic.goto_next,
    ["<leader>q"] = vim.diagnostic.setloclist,
    ["<leader>f"] = function() vim.lsp.buf.format { async = true } end,
  }, nil, nil, opts)
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
M.capabilities = require("cmp_nvim_lsp").update_capabilities(M.capabilities)
-- M.capabilities = require'coq'.lsp_ensure_capabilities(M.capabilities)

M.quirks = {
}

M.init = function(force)
  if not force and not require("private").try_run "LSP_INIT" then
    return
  end
  require'nvim-lsp-installer'.setup {
    automatic_installaction = true,
  }
  for _, lsp in ipairs(M.servers) do
    if lsp == nil then
      print(_, "nil")
    else
      M.setup_server(lsp)
    end
  end
end

M.reload = function()
  package.loaded["private.lspcfg"] = nil
  require("private.lspcfg").init(true)
end
Lspcfg = M
return M
