local function lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return capabilities
  -- return vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
end

---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:mason-org/mason-registry',
            'github:nvim-java/mason-registry',
            'github:Crashdummyy/mason-registry',
          },
        },
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        dependencies = {
          { 'Bilal2453/luvit-meta', lazy = true },
        },
        opts = {
          library = {
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          },
        },
      },
      { 'folke/neoconf.nvim', opts = {} },
      {
        dir = '~/personal/rzls.nvim',
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local mapv = function(keys, func, desc)
            vim.keymap.set('v', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          mapv('<C-a>', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      require('mason').setup()

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        -- Java packages
        'lombok-nightly',
        -- 'openjdk-17',
        'jdtls',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      local capabilities = lsp_capabilities()
      local disabled_lsp = { 'jdtls', 'hls' }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            -- jdtls setup is handled by a custom plugin
            if vim.tbl_contains(disabled_lsp, server_name) then
              return
            end

            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  {
    'seblj/roslyn.nvim',
    ft = { 'cs', 'razor' },
    dependencies = {
      { dir = '~/personal/rzls.nvim' },
      'williamboman/mason.nvim',
    },
    config = function()
      local capabilities = lsp_capabilities()
      local rzls_path = vim.fs.joinpath(require('mason-registry').get_package('rzls'):get_install_path(), 'libexec')

      require('roslyn').setup {
        filewatching = true,
        capabilities = capabilities,
        args = {
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
          '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'),
        },
        config = {
          handlers = require 'rzls.roslyn_handlers',
        },
      }

      require('rzls').setup {
        capabilities = capabilities,
        path = vim.fs.joinpath(rzls_path, 'rzls'),
      }
    end,
  },
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^3',
  },
  'mfussenegger/nvim-jdtls',
  { 'numToStr/Comment.nvim', opts = {} },
}
