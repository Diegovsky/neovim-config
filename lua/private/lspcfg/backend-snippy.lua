local M = {}

local snippy = require'snippy'
local partial = require'private'.partial

local can_scroll_table = {
  next = partial(snippy.can_jump, 1),
  prev = partial(snippy.can_jump, -1),
}
--- @param direction ScrollDir
function M.can_scroll(direction)
  return can_scroll_table[direction]()
end

local scroll_table = {
  prev = snippy.advance,
  next = snippy.previous
}

function M.can_expand_or_scroll()
  return snippy.can_expand_or_advance()
end

function M.expand_or_scroll()
  return snippy.expand_or_advance()
end

---@param direction ScrollDir
function M.scroll(direction)
  return scroll_table[direction]()
end

function M.expand(args)
  return snippy.expand_snippet(args.body)
end

function M.cmp_source()
  return { name = "snippy" }
end

return M
