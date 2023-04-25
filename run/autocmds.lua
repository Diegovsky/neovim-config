local augp = vim.api.nvim_create_augroup('PrivGrp', {clear=true})

local function autocmd(event, pat, callback)
  vim.api.nvim_create_autocmd(event, {
    group=augp,
    pattern = pat,
    callback = callback,
  })
end

autocmd('DirChanged', '*', function() io.write('\27]7;file://'..vim.fn.getcwd()..'\27\\') end)
