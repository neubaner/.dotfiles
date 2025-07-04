---@type LazySpec[]
return {
  {
    'saghen/blink.cmp',
    version = '*',
    enabled = true,
    dependencies = {
      'rafamadriz/friendly-snippets',
      {
        'Kaiser-Yang/blink-cmp-git',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      'Kaiser-Yang/blink-cmp-avante',
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      signature = { enabled = true },
      sources = {
        default = { 'avante', 'git', 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          git = {
            module = 'blink-cmp-git',
            name = 'Git',
            score_offset = 100,
            enabled = true,
            should_show_items = function()
              local fts = { 'gitcommit', 'markdown' }
              return vim.tbl_contains(fts, vim.o.filetype)
            end,
            ---@module 'blink-cmp-git'
            ---@type blink-cmp-git.Options
            opts = {},
          },
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    enabled = false,
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      { 'petertriho/cmp-git', opts = {} },
      'onsails/lspkind.nvim',
      'brenoprata10/nvim-highlight-colors',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'
      local highlight_colors = require 'nvim-highlight-colors'

      lspkind.init {}
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'git' },
        },
        formatting = {
          format = function(entry, item)
            local color_item = highlight_colors.format(entry, { kind = item.kind })
            item = lspkind.cmp_format {
              mode = 'symbol_text',
              maxwidth = 50,
              ellipsis_char = '...',
              show_labelDetails = true,
              before = function(_, vim_item)
                return vim_item
              end,
            }(entry, item)

            if color_item.abbr_hl_group then
              item.kind_hl_group = color_item.abbr_hl_group
              item.kind = color_item.abbr
            end

            return item
          end,
        },
      }
    end,
  },
}
