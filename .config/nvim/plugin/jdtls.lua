local jdtls = require('jdtls')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'java' },
  once = true,
  callback = function()
    vim.lsp.enable({
      'jdtls',
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('jdtls-lsp-attach', { clear = true }),
      pattern = { '*.java' },
      callback = function(event)
        vim.keymap.set('n', '<leader>df', function()
          jdtls.test_class()
        end, { desc = 'Run Java tests', buffer = event.buf })

        vim.keymap.set('n', '<leader>dn', function()
          jdtls.test_nearest_method()
        end, { desc = 'Run nearest Java test', buffer = event.buf })
      end,
    })

    vim.api.nvim_create_autocmd('BufWritePost', {
      group = vim.api.nvim_create_augroup('jdtls-reload-projects', { clear = true }),
      pattern = { 'build.gradle.kts', 'build.gradle', 'settings.gradle.kts', 'settings.gradle' },
      callback = function(event)
        local jdtls_clients = vim.lsp.get_clients({ name = 'jdtls' })

        if #jdtls_clients > 0 then
          local file_path = vim.api.nvim_buf_get_name(event.buf)
          local file_directory = vim.fn.fnamemodify(file_path, ':h')

          for _, jdtls_client in ipairs(jdtls_clients) do
            jdtls_client:notify('java/projectConfigurationsUpdate', {
              identifiers = { { uri = file_directory } },
            })

            jdtls_client:request('java/buildProjects', {
              identifiers = { { uri = file_directory } },
              isFullBuild = true,
            }, function(err, result, context, config)
              if err ~= nil then
                vim.notify(err.message, vim.log.levels.ERROR)
              end
            end)
          end
        end
      end,
    })
  end,
})
