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
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        cmd = 'LazyDev',
        opts = {
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            { path = 'lazy.nvim', words = { 'Lazy' } },
          },
        },
      },
      { 'folke/neoconf.nvim', opts = {} },
      'folke/trouble.nvim',
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
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = true })
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

            local codelens_augroup = vim.api.nvim_create_augroup('lsp-codelens', { clear = true })
            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
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

      vim.lsp.enable { 'phpactor' }
    end,
  },
  {
    'seblj/roslyn.nvim',
    ft = { 'cs', 'razor' },
    dependencies = {
      { 'tris203/rzls.nvim', opts = {} },
      'mason-org/mason.nvim',
    },
    ---@type RoslynNvimConfig
    opts = {
      filewatching = 'roslyn',
    },
    config = function(_, opts)
      require('roslyn').setup(opts)

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
  },
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    dependencies = { 'mason-org/mason.nvim' },
  },
}
