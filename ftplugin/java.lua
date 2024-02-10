local ok, status = pcall(function()
  local config = {
    cmd = { vim.fn.exepath('jdtls') },
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'pom.xml', 'build.gradle', 'mvnw'}, {upward=true})[1]),
    on_attach = require'private.lspcfg'.on_attach
  }
  require'jdtls'.start_or_attach(config)
end)

require('jdtls.ui').pick_many = function(items, prompt, label_f, opts)
  local co = coroutine.running()
  vim.ui.select(items, {prompt=prompt, format_item=label_f}, function(result)
    coroutine.resume(co, { result })
  end)
  return coroutine.yield()
end

if not ok then
  print('Error initializing jdtls: '..status)
end
