local lspconfig = require "lspconfig"
--- @class Privlspcfg
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
  "lua_ls",
  "teal_ls",
  "vala_ls",
  "tsserver",
  "gdscript",
  "r_language_server",
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
  args = vim.tbl_deep_extend('force', args, opt or {})
  if name == "rust_analyzer" then
    require("rust-tools").setup { server = args }
  elseif name == 'dartls' then
    require'flutter-tools'.setup({
      lsp = args
    })

  else
    lspconfig[name].setup(args)
  end
end


---@diagnostic disable-next-line: unused-local
M.on_attach = function(_client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  require'private.lspcfg.cmp'.cmp_init()

  dofile(NVIM_CONFIG_FOLDER..'/run/highlight.lua')

  require("private.keybindutils").declmaps("n", {
    ["gD"] = vim.lsp.buf.declaration,
    ["gd"] = vim.lsp.buf.definition,
    ["gi"] = vim.lsp.buf.implementation,
    ["gr"] = vim.lsp.buf.references,
    ["go"] = vim.lsp.buf.type_definition,
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


function M.make_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.foldingRange = {
      dynamicRegistration = true,
      lineFoldingOnly = true
  }
  --[[ capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  } ]]


  return capabilities
end

M.quirks = { }

M.init = function()
  for _, lsp in ipairs(M.servers) do
    M.setup_server(lsp)
  end
end

M.reload = function()
  package.loaded["private.lspcfg"] = nil
  require("private.lspcfg").init(true)
end

return Priv.insertlazy('private.lspcfg', M)
