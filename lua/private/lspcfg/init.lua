local lspconfig = require "lspconfig"
local partial = require 'private'.partial
--- @class Privlspcfg
local M = {}

M.servers = {
    "clangd",
    "csharp_ls",
    -- "ccls",
    "dartls",
    "emmet_ls",
    "fennel_ls",
    "gdscript",
    "gopls",
    "hls",
    "lemminx", -- xml server
    "lua_ls",
    "rust_analyzer",
    "solargraph", -- ruby lsp
    "ts_ls",
    "vala_ls",
    "zls",
}

if require 'private'.executable('basedpyright') then
    table.insert(M.servers, 'basedpyright')
else
    table.insert(M.servers, 'pyright')
end

--- @param name string
function M.setup_server(name)
    local args = {
        on_attach = M.on_attach,
        capabilities = M.make_capabilities(),
        flags = {
            debounce_text_changes = 150,
        },
    }
    if name == "rust_analyzer" then
        -- already done by rustaceanvim :)
    elseif name == 'dartls' then
        require 'flutter-tools'.setup({
            lsp = args
        })
    else
        lspconfig[name].setup(args)
    end
end

--- @param movement 'prev'?
local function error_jump(movement)
    local count = 1
    if movement == 'prev' then
        count = -1
    end
    vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = count }
end


---@diagnostic disable-next-line: unused-local
M.on_attach = function(_client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    require 'private.lspcfg.cmp'.cmp_init()

    dofile(NVIM_CONFIG_FOLDER .. '/run/highlight.lua')

    require("keymaps").declare_keys("n", {
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
        ["[d"] = error_jump,
        ["]d"] = partial(error_jump, 'prev'),
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
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }
    return capabilities
end

M.init = function()
    for _, lsp in ipairs(M.servers) do
        M.setup_server(lsp)
    end
end

M.reload = function()
    package.loaded["private.lspcfg"] = nil
    require("private.lspcfg").init(true)
end

return M
