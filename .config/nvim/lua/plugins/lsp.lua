---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {
          registries = {
            'github:mason-org/mason-registry',
            'github:Crashdummyy/mason-registry',
          },
        },
      },
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbol')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, event.buf) then
            local enabled = false
            map('<leader>tc', function()
              enabled = not enabled
            end, '[T]oggle [C]ode Lens')

            local codelens_augroup = vim.api.nvim_create_augroup('lsp-codelens', { clear = false })
            vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
              group = codelens_augroup,
              buffer = event.buf,
              callback = function(ev)
                if enabled then
                  vim.lsp.codelens.refresh { bufnr = ev.buf }
                else
                  vim.lsp.codelens.clear(client.id, ev.buf)
                end
              end,
            })
          end
        end,
      })

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_enable = {
          exclude = { 'jdtls', 'hls' },
        },
      }

      vim.lsp.enable {
        'phpactor',
        'kotlin_language_server',
        'nil_ls',
        'lua_ls',
        'clangd',
      }
    end,
  },
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^3',
    ft = { 'haskell', 'lhaskell' },
  },
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    dependencies = { 'mason-org/mason.nvim' },
    config = function()
      vim.lsp.enable 'jdtls'

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('jdtls-lsp-attach', { clear = true }),
        pattern = { '*.java' },
        callback = function(event)
          vim.keymap.set('n', '<leader>df', function()
            require('jdtls').test_class()
          end, { desc = 'Run Java tests', buffer = event.buf })

          vim.keymap.set('n', '<leader>dn', function()
            require('jdtls').test_nearest_method()
          end, { desc = 'Run nearest Java test', buffer = event.buf })
        end,
      })

      vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('jdtls-reload-projects', { clear = true }),
        pattern = { 'build.gradle.kts', 'build.gradle', 'settings.gradle.kts', 'settings.gradle' },
        callback = function(event)
          local jdtls_clients = vim.lsp.get_clients { name = 'jdtls' }

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
  },
}
