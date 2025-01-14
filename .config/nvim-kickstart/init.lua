vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.o.termguicolors = true
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local setupNeovide = function()
  if vim.g.neovide then
    local font_size = 13
    local fonts = {
      'IosevkaTerm Nerd Font Mono',
      'JetbrainsMono Nerd Font Mono',
    }

    vim.opt.guifont = table.concat(fonts, ',') .. ':h' .. font_size
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_trail_size = 0
  end
end

vim.api.nvim_create_autocmd('UIEnter', {
  desc = 'Setup Neovide',
  group = vim.api.nvim_create_augroup('kickstart-neovide-setup', { clear = true }),
  callback = function()
    setupNeovide()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'tpope/vim-sleuth', enabled = true }, -- Detect tabstop and shiftwidth automatically
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()

      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>c_', hidden = true },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>d_', hidden = true },
        { '<leader>r', group = '[R]ename' },
        { '<leader>r_', hidden = true },
        { '<leader>s', group = '[S]earch' },
        { '<leader>s_', hidden = true },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>w_', hidden = true },
      }
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

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
        'seblj/roslyn.nvim',
        ft = 'cs',
      },
      'mfussenegger/nvim-jdtls',
      {
        dir = '~/personal/rzls.nvim',
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
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

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

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

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        -- Java packages
        'lombok-nightly',
        -- 'openjdk-17',
        'jdtls',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('lsp.jdtls').setup {
        capabilities = capabilities,
      }

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
    'mrcjkb/haskell-tools.nvim',
    version = '^3',
    lazy = false,
  },

  {
    'stevearc/conform.nvim',
    opts = function()
      return {
        notify_on_error = false,
        format_on_save = function(bufnr)
          local disable_filetypes = { c = true, cpp = true, razor = true, java = false }
          return {
            timeout_ms = 5000,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          proto = { 'buf' },
          hcl = { 'hcl' },
          markdown = { 'markdownlint' },
          terraform = { 'hcl' },
          php = { 'pint' },
          java = { 'spotless' },
          ['terraform-vars'] = { 'hcl' },
        },
        log_level = vim.log.levels.DEBUG,
        formatters = {
          spotless = {
            condition = function(_, ctx)
              return vim.bo[ctx.buf].filetype == 'java'
            end,
            cwd = vim.print(require('conform.util').root_file { '.git', 'mvnw', 'gradlew' }),
            command = './gradlew',
            args = function(_, ctx)
              return {
                'spotlessApply',
                '--quiet',
                '-PspotlessIdeHook=' .. ctx.filename,
                '-PspotlessIdeHookUseStdIn',
                '-PspotlessIdeHookUseStdOut',
              }
            end,
            stdin = true,
          },
        },
      }
    end,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
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
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
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

  {
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'tokyonight-moon'
      vim.cmd.hi 'Comment gui=none'
    end,
    config = function()
      require('tokyonight').setup {
        on_highlights = function(highlights, colors)
          highlights.LspCodeLens = { fg = colors.comment }
        end,
      }
    end,
  },
  {
    'AlexvZyl/nordic.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('nordic').load()
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      highlight = {
        keyword = 'wide',
        pattern = [[.*<(KEYWORDS)\s*(\(.*\))?\s*:]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\s*(\(.*\))?:]],
      },
    },
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
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
      ---@type ParserInfo
      require('nvim-treesitter.parsers').get_parser_configs().razor = {
        install_info = {
          url = 'https://github.com/tris203/tree-sitter-razor',
          files = { 'src/parser.c', 'src/scanner.c' },
          revision = '6305416578d59861ae85300546b4c3bac839ea9e',
        },
        filetype = 'razor',
      }

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup {}

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      for idx, key in ipairs { 'j', 'k', 'l', ';' } do
        vim.keymap.set('n', string.format('<space>%s', key), function()
          harpoon:list():select(idx)
        end, {
          desc = 'Harpoon select ' .. idx,
        })
      end
    end,
  },

  {
    'xiyaowong/transparent.nvim',
    config = function() end,
  },

  {
    'ray-x/lsp_signature.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {},
  },
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  {
    'stevearc/oil.nvim',
    lazy = false,
    ---@type oil.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      default_file_explorer = true,
      ---@diagnostic disable-next-line: missing-fields
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ['gg'] = {
          desc = 'Navigate down recursively',
          callback = function()
            local function get_leaf_path(parent)
              local children = {}
              for child in vim.fs.dir(parent) do
                table.insert(children, vim.fs.joinpath(parent, child))
              end

              if #children == 1 and vim.fn.isdirectory(children[1]) == 1 then
                return get_leaf_path(children[1])
              end

              return parent
            end

            local oil = require 'oil'
            local current_entry = oil.get_cursor_entry()

            if current_entry == nil or current_entry.type ~= 'directory' then
              oil.select()
            end

            local leaf_path = get_leaf_path(vim.fs.joinpath(oil.get_current_dir(), oil.get_cursor_entry().parsed_name))
            oil.open(leaf_path)
          end,
        },
        -- TODO: Navigate up recursively
        -- ['__'] = {
        --   desc = 'Navigate up recursively',
        --   callback = function()
        --     local function get_leaf_path(parent)
        --       local children = {}
        --       for child in vim.fs.dir(parent) do
        --         table.insert(children, vim.fs.joinpath(parent, child))
        --       end
        --
        --       if #children == 1 and vim.fn.isdirectory(children[1]) == 1 then
        --         return get_leaf_path(children[1])
        --       end
        --
        --       return parent
        --     end
        --
        --     local oil = require 'oil'
        --     local current_entry = oil.get_cursor_entry()
        --
        --     if current_entry == nil or current_entry.type ~= 'directory' then
        --       oil.select()
        --     end
        --
        --     local leaf_path = get_leaf_path(vim.fs.joinpath(oil.get_current_dir(), oil.get_cursor_entry().parsed_name))
        --     oil.open(leaf_path)
        --   end,
        -- },
      },
    },
    keys = {
      { '-', '<CMD>Oil<CR>', desc = 'Open parent directory', mode = 'n' },
      {
        '<leader>-',
        function()
          require('oil').toggle_float()
        end,
        desc = 'Open parent directory',
        mode = 'n',
      },
    },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
  {
    'MeanderingProgrammer/markdown.nvim',
    enabled = false,
    main = 'render-markdown',
    opts = {},
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  {
    'OXY2DEV/markview.nvim',
    enabled = true,
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },
  {
    'christoomey/vim-tmux-navigator',
  },
  {
    'ramojus/mellifluous.nvim',
    enabled = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('mellifluous').setup {}
      vim.cmd 'colorscheme mellifluous'
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
    enabled = false,
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
  {
    'rcarriga/nvim-notify',
    priority = 1000,
    init = function()
      vim.notify = require 'notify'
    end,
  },
  'AndrewRadev/bufferize.vim',
  { 'brenoprata10/nvim-highlight-colors', opts = {} },
  {
    'folke/noice.nvim',
    enabled = false,
    event = 'VeryLazy',
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,

        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },
  {
    'GustavEikaas/easy-dotnet.nvim',
    ft = 'cs',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      require('easy-dotnet').setup {
        get_sdk_path = function()
          local sdk_version = vim.system({ 'dotnet', '--version' }):wait().stdout:gsub('\r', ''):gsub('\n', '')
          return vim.fs.joinpath(vim.fn.expand '$HOME', '.dotnet', 'sdk', sdk_version)
        end,
      }
    end,
    opts = {},
  },
  {
    'ficcdaf/ashen.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'ashen'
      require('ashen').load()
    end,
    opts = {},
  },
  { import = 'custom.plugins' },
  { import = 'test' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

require('debug.csharp').setup()
require 'debug.csharp.docker'

vim.filetype.add {
  extension = {
    te = 'teika',
    tei = 'teika',
  },
}

vim.api.nvim_create_user_command('RazorReload', function()
  require('plenary.reload').reload_module('rzls.utils', false)
end, {})

vim.treesitter.language.register('markdown', 'octo')

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
  vim.cmd [[TSInstall razor]]
end, {
  desc = 'Build tree sitter and install',
})

vim.api.nvim_create_user_command('LspStopAll', function()
  local lsp_clients = vim.lsp.get_clients()

  for _, lsp_client in ipairs(lsp_clients) do
    lsp_client.stop()
  end
end, {})

vim.lsp.set_log_level 'DEBUG'

-- vim: ts=2 sts=2 sw=2 et
