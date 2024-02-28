local M = {}

local luasnip = require'luasnip'
local partial = require'private'.partial

local can_scroll_table = {
  next = partial(luasnip.jumpable, 1),
  prev = partial(luasnip.jumpable, -1)
}
--- @param direction ScrollDir
function M.can_scroll(direction)
  return can_scroll_table[direction]()
end

local scroll_table = {
  prev = partial(luasnip.jump, -1),
  next = partial(luasnip.jump, 1),
}

---@param direction ScrollDir
function M.scroll(direction)
  return scroll_table[direction]()
end

function M.can_expand_or_scroll()
  return luasnip.expand_or_jumpable()
end

function M.expand_or_scroll()
  return luasnip.expand_or_jump()
end

function M.expand(args)
  return luasnip.lsp_expand(args.body)
end

function M.cmp_source()
  return { name = 'luasnip', option = { use_show_condition = false } }
end

return M
