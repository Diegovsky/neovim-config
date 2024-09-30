--- @alias ScrollDir 'next'|'prev'

--- @class SnippetBackend
--- @field can_scroll fun(direction: ScrollDir): boolean
--- @field scroll fun(direction: ScrollDir)
--- @field cmp_source fun(): table
--- @field can_expand_or_scroll fun(): boolean
--- @field expand fun(args: any): any
--- @field expand_or_scroll fun(): any
local snippet_engine = nil


for _, backend in ipairs({'luasnip'}) do
  local status, _ = pcall(require, backend)
  if status then
    snippet_engine = require('private.lspcfg.backend-'..backend)
    snippet_engine.name = backend
    break
  end
end

return snippet_engine
