local M = {}

local cmp = require'cmp'
local snippy = require'snippy'

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
  else
    fallback()
  end
end

M.cmp_init = function(force)
  force = force or false
  if not force and not require("private").try_run "CMP_INIT" then
    return false
  end
  local compare = require "cmp.config.compare"
  cmp.setup {
    snippet = {
      expand = function(args)
        require("snippy").expand_snippet(args.body)
      end,
    },
    sorting = {
      priority_weight = 1.0,
      comparators = {
        -- compare.score_offset, -- not good at allcompare.locality,
        compare.recently_used,
        compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
        compare.offset,
        compare.order,
        -- compare.scopes, -- what?
        -- compare.sort_text,
        -- compare.exact,
        -- compare.kind,
        -- compare.length, -- useless
      },
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm {
        select = true,
        -- behavior = cmp.ConfirmBehavior.Replace,
      },
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

M.snippets_init = function()
  local snippets = require "snippy"
  local opts = {
    expr = true,
    remap = true,
  }
  local function jump_next()
    return snippets.can_jump(1) and "<Plug>(snippy-next)" or "<Tab>"
  end

  local function jump_prev()
    return snippets.can_jump(-1) and "<Plug>(snippy-previous)" or "<S-Tab>"
  end

  local function expand_or_advance()
    return snippets.can_expand() and "<Plug>(snippy-expand)" or jump_next()
  end

  vim.keymap.set("i", "<Tab>", expand_or_advance, opts)
  vim.keymap.set("s", "<Tab>", jump_next, opts)
  vim.keymap.set({ "i", "s" }, "<S-Tab>", jump_prev, opts)
  vim.keymap.set("x", "<Tab>", "<Plug>(snippy-cut-text)", opts)
  vim.keymap.set("n", "g<Tab>", "<Plug>(snippy-cut-text)", opts)
end

return M
