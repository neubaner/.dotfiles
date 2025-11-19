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
      }
    end,
  },
  {
    'seblj/roslyn.nvim',
    dependencies = {
      { dir = '~/personal/rzls.nvim', config = true },
      'mason-org/mason.nvim',
    },
    ft = { 'cs', 'razor' },
    config = function()
      require('roslyn').setup {
        broad_search = true,
        lock_target = true,
        filewatching = 'off',
      }

      local rzls_path = vim.fn.expand '$MASON/packages/rzls/libexec/'
      vim.lsp.config('roslyn', {
        cmd = {
          'roslyn',
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
          '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'),
          '--extension',
          vim.fs.joinpath(rzls_path, 'RazorExtension', 'Microsoft.VisualStudioCode.RazorExtension.dll'),
        },
        handlers = require 'rzls.roslyn_handlers',
        settings = {
          ['csharp|background_analysis'] = {
            dotnet_analyzer_diagnostics_scope = 'fullSolution',
            dotnet_compiler_diagnostics_scope = 'fullSolution',
          },
          ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = false,
            csharp_enable_inlay_hints_for_types = false,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ['csharp|symbol_search'] = {
            dotnet_search_reference_assemblies = true,
          },
          ['csharp|completion'] = {
            dotnet_show_name_completion_suggestions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_provide_regex_completions = true,
          },
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })

      -- From: https://github.com/seblyng/roslyn.nvim/wiki
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          if client and (client.name == 'roslyn' or client.name == 'roslyn_ls') then
            vim.api.nvim_create_autocmd('InsertCharPre', {
              desc = "Roslyn: Trigger an auto insert on '/'.",
              buffer = bufnr,
              callback = function()
                local char = vim.v.char

                if char ~= '/' then
                  return
                end

                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                row, col = row - 1, col + 1
                local uri = vim.uri_from_bufnr(bufnr)

                local params = {
                  _vs_textDocument = { uri = uri },
                  _vs_position = { line = row, character = col },
                  _vs_ch = char,
                  _vs_options = {
                    tabSize = vim.bo[bufnr].tabstop,
                    insertSpaces = vim.bo[bufnr].expandtab,
                  },
                }

                -- NOTE: We should send textDocument/_vs_onAutoInsert request only after
                -- buffer has changed.
                vim.defer_fn(function()
                  client:request(
                    ---@diagnostic disable-next-line: param-type-mismatch
                    'textDocument/_vs_onAutoInsert',
                    params,
                    function(err, result, _)
                      if err or not result then
                        return
                      end

                      vim.snippet.expand(result._vs_textEdit.newText)
                    end,
                    bufnr
                  )
                end, 1)
              end,
            })
          end
        end,
      })
    end,
    init = function()
      vim.filetype.add {
        extension = {
          razor = 'razor',
          cshtml = 'razor',
        },
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
