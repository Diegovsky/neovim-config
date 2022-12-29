local lspconfig = require "lspconfig"
--- @class Pluglspcfg
local M = {}

M.servers = {
  "clangd",
  -- "ccls",
  "dartls",
  "emmet_ls",
  "gopls",
  "hls",
  "lemminx", -- xml server
  "pyright",
  "rust_analyzer",
  "solargraph", -- ruby lsp
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
  args = require'private.lspcfg.profiles'.apply_profile(name, args)
  args = vim.tbl_deep_extend('force', args, opt or {})
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
  local opts = { noremap = true, silent = true, buffer = bufnr }
  require'private.lspcfg.cmp'.cmp_init(true)

  require("private.keybindutils").declmaps("n", {
    ["gD"] = vim.lsp.buf.declaration,
    ["gd"] = vim.lsp.buf.definition,
    ["gi"] = vim.lsp.buf.implementation,
    ["gr"] = vim.lsp.buf.references,
    ["gt"] = vim.lsp.buf.type_definition,
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

M.capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

M.quirks = { }

M.init = function(force)
  if not force and not require("private").run_once "LSP_INIT" then
    return
  end
  for _, lsp in ipairs(M.servers) do
    M.setup_server(lsp)
  end
end

M.reload = function()
  package.loaded["private.lspcfg"] = nil
  require("private.lspcfg").init(true)
end
return Priv.insertlazy('private.lspcfg', M)
