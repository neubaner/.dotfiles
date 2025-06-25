vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

vim.api.nvim_create_user_command('PasteJavaString', function(opts)
  local register_content = vim.fn.getreg(opts.args)
  local lines = vim.split(register_content, '\n', { plain = true })

  local java_lines = {}
  for index, line in ipairs(lines) do
    local java_line = ''

    if index ~= 1 then
      java_line = '+ '
    end

    if index ~= #lines then
      java_line = java_line .. '"' .. line .. '\\n"'
    else
      java_line = java_line .. '"' .. line .. '"'
    end

    table.insert(java_lines, java_line)
  end

  vim.api.nvim_put(java_lines, 'l', true, false)
end, { nargs = 1 })
