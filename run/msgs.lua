-- this is a substitute for the noice plugin,
-- so don't do anything if it is loaded
if package.loaded['noice'] then
  return
end

require('notify').setup({
  fps=60,
  minimum_width=20,
  maximum_heght=10,
  timeout=1000,
  max_width=70,
})

---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level)
  if level == vim.log.levels.ERROR or level == vim.log.levels.WARN then
    require 'notify' (msg, level)
  else
    print(msg)
  end
end
