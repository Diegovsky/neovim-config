local M = {}

local cmp = require'cmp'
local snippy = require'snippy'
local dbg = require'private'.debug

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function tab(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif snippy.can_expand_or_advance() then
    snippy.expand_or_advance()
  elseif has_words_before() then
      cmp.complete()
  else
    fallback()
  end
end

local function stab(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif snippy.can_jump(-1) then
    snippy.previous()
  elseif has_words_before() then
      cmp.complete()
  else
    fallback()
  end
end

M.cmp_init = function(force)
  force = force or false
  if not force and not require("private").run_once "CMP_INIT" then
    return false
  end
  vim.o.completeopt = 'menu,menuone,noselect'
  require'private.lspcfg.highlight'
  local compare = require "cmp.config.compare"
  cmp.setup {
    completion = {
      keyword_length=2,
      autocomplete=false
    },
    view = {
      entries = { name='custom', selection_order='near_cursor' }
    },
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
        kind.kind = " " .. strings[1] .. " "
        kind.menu = "    (" .. strings[2] .. ")"
        return kind
      end,
    },
    snippet = {
      expand = function(args)
        require("snippy").expand_snippet(args.body)
      end,
    },
    sorting = {
      priority_weight = 1.0,
      comparators = {
        -- compare.score_offset, -- not good at all
        compare.locality,
        compare.exact,
        compare.recently_used,
        compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
        compare.kind,
        compare.offset,
        compare.order,
        -- compare.scopes, -- what?
        -- compare.sort_text,
        -- compare.length, -- useless
      },
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({
        select = true,
        -- behavior = cmp.ConfirmBehavior.Replace,
      }, snippy.expand_or_advance),
      ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
      ["<S-tab>"] = cmp.mapping(stab, { "i", "s" }),
      ["<down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
      ["<up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "snippy" },
    },
  }

  -- Prevemt cmp from messing with telescope
  vim.api.nvim_exec(
    "autocmd FileType TelescopePrompt lua require('cmp').setup.buffer{enable=false}",
    true
  )
end

return M
