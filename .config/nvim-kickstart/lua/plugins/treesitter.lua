---@type LazySpec[]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'razor' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'https://github.com/Samonitari/tree-sitter-caddy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        require('nvim-treesitter.parsers').get_parser_configs().caddy = {
          install_info = {
            url = 'https://github.com/Samonitari/tree-sitter-caddy',
            files = { 'src/parser.c', 'src/scanner.c' },
            branch = 'master',
          },
          filetype = 'caddy',
        }

        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { 'caddy' })
        vim.filetype.add {
          pattern = {
            ['Caddyfile'] = 'caddy',
          },
        }
      end,
    },
    event = 'BufRead Caddyfile',
  },
  {
    'https://github.com/tris203/tree-sitter-razor',
    enabled = true,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        ---@type ParserInfo
        require('nvim-treesitter.parsers').get_parser_configs().razor = {
          install_info = {
            url = 'https://github.com/tris203/tree-sitter-razor',
            files = { 'src/parser.c', 'src/scanner.c' },
            branch = 'main',
          },
          filetype = 'razor',
        }

        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'razor')
      end,
    },
  },
}
