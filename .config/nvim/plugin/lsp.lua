require('mason').setup({
  registries = {
    'github:mason-org/mason-registry',
    'github:Crashdummyy/mason-registry',
  },
})

require('mason-lspconfig').setup({
  ensure_installed = {},
  automatic_enable = { exclude = { 'jdtls', 'hls' } },
})

vim.lsp.enable({
  'nil_ls',
})

local lspkind = require('lspkind')

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

    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>it', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end

    if client and client:supports_method('textDocument/codeLens', event.buf) then
      map('<leader>ct', function()
        vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = event.buf }))
      end, '[T]oggle [C]ode Lens')

      map('<leader>cr', function()
        vim.lsp.codelens.run({ client_id = client.id })
      end, '[R]un [C]ode Lens')
    end

    if client and client:supports_method('textDocument/completion', event.buf) then
      vim.bo[event.buf].autocomplete = true
      vim.lsp.completion.enable(true, client.id, event.buf, {
        convert = function(item)
          local kind = ''
          for str, int in pairs(vim.lsp.protocol.CompletionItemKind) do
            if int == item.kind then
              kind = str
              break
            end
          end

          return {
            kind = kind .. ' ' .. (lspkind.symbol_map[kind] or ''),
            -- catppuccin define blink.cmp highlights
            kind_hlgroup = 'BlinkCmpKind' .. kind,
          }
        end,
      })
    end
  end,
})
