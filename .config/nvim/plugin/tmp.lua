vim.api.nvim_create_user_command('RazorReload', function()
  require('plenary.reload').reload_module('rzls.utils', false)
end, {})

vim.keymap.set('n', '<leader>ct', function()
  require('nvim-treesitter.query').invalidate_query_cache 'c_sharp'
  vim.cmd [[InspectTree]]
end)

vim.keymap.set('n', '<leader>tb', function()
  local generate_result = vim.system({ 'tree-sitter', 'generate' }, { text = true }):wait()
  if generate_result.code ~= 0 then
    vim.notify('Failed to generate tree-sitter parser\n' .. generate_result.stderr, vim.log.levels.ERROR, {
      title = 'tree-sitter builder',
    })
    return
  end

  vim.cmd [[TSInstall razor]]
end, {
  desc = 'Build tree sitter and install',
})

vim.api.nvim_create_user_command('LspStopAll', function()
  local lsp_clients = vim.lsp.get_clients()

  for _, lsp_client in ipairs(lsp_clients) do
    lsp_client:stop()
  end
end, {})

vim.lsp.set_log_level 'DEBUG'
