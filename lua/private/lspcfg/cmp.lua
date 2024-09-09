local recget = require'private'.recget
local cmp = require'cmp'
local snippets = require'private.lspcfg.snippets'

local M = {}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local tab = cmp.mapping(function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    elseif has_words_before() then
        cmp.complete()
    else
        fallback()
    end
end)

local stab = cmp.mapping(function(fallback)
    if cmp.visible() then
        cmp.select_prev_item()
    else
        fallback()
    end
end)

M.cmp_init = function()

    dofile(NVIM_CONFIG_FOLDER..'/run/highlight.lua')

    vim.o.completeopt = 'menu,preview,menuone,noselect'
    local compare = require "cmp.config.compare"
    ---@diagnostic disable-next-line: redundant-parameter
    cmp.setup {
        view = {
            entries = { name='custom' }
        },
        performance = {
            fetching_timeout = 20,
            debounce = 40,
        },
        --[[ completion = {
      keyword_pattern
    }, ]]
        window = {
            completion = {
                winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                col_offset = -3,
                side_padding = 0,
            },
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                kind.kind = " " .. tostring(strings[1]) .. " "
                kind.menu = "    (" .. tostring(strings[2]) .. ")"
                return kind
            end,
        },
        snippet = {
            expand = snippets.expand,
        },
        matching = {
            disallow_fuzzy_matching = false,
            disallow_prefix_unmatching = true,
            disallow_partial_matching = false,
        },
        sorting = {
            priority_weight = 1.0,
            comparators = {
                compare.score,
                compare.exact,
                compare.length,
                compare.kind,
                compare.scopes,
                compare.recently_used,
                compare.offset,
                compare.locality
            },
        },
        mapping = {
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({
                select = true,
                behavior = cmp.ConfirmBehavior.Replace,
            }),
            ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
            ["<S-tab>"] = cmp.mapping(stab, { "i", "s" }),
            ["<down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
            ["<up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
        },
        sources = {
            { name = "nvim_lsp", priority=2, max_item_count = 100, entry_filter = function(entry, ctx)
                -- filter out owo_colorize
                local item = entry:get_completion_item()
                local imports = recget(item, 'data.imports')
                if imports then
                    for _, import in ipairs(imports) do
                        local path = import.full_import_path
                        if path and string.match(path, 'owo') then
                            return false
                        end
                    end
                end
                return true
            end },
            snippets.cmp_source(),
        },
    }

    -- Prevemt cmp from messing with telescope
    ---@diagnostic disable-next-line: missing-fields
    vim.api.nvim_create_autocmd('FileType', {pattern='TelescopePrompt', callback=function() require'cmp'.setup.buffer{enabled=false} end})
end

return M
