vim.loader.enable()

require('vim._core.ui2').enable({
  enable = true,
  -- msg = {
  --   targets = {
  --     [''] = 'msg',
  --     empty = 'cmd',
  --     bufwrite = 'msg',
  --     confirm = 'cmd',
  --     emsg = 'pager',
  --     echo = 'msg',
  --     echomsg = 'msg',
  --     echoerr = 'pager',
  --     completion = 'cmd',
  --     list_cmd = 'pager',
  --     lua_error = 'pager',
  --     lua_print = 'msg',
  --     progress = 'pager',
  --     rpc_error = 'pager',
  --     quickfix = 'msg',
  --     search_cmd = 'cmd',
  --     search_count = 'cmd',
  --     shell_cmd = 'pager',
  --     shell_err = 'pager',
  --     shell_out = 'pager',
  --     shell_ret = 'msg',
  --     undo = 'msg',
  --     verbose = 'pager',
  --     wildlist = 'cmd',
  --     wmsg = 'msg',
  --     typed_cmd = 'cmd',
  --   },
  --   cmd = {
  --     height = 0.5,
  --   },
  --   dialog = {
  --     height = 0.5,
  --   },
  --   msg = {
  --     height = 0.3,
  --     timeout = 5000,
  --   },
  --   pager = {
  --     height = 0.5,
  --   },
  -- },
})

local opt = vim.opt

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

opt.cmdheight = 1
opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.showmode = false
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split'
opt.cursorline = true
opt.scrolloff = 10
opt.termguicolors = true
opt.hlsearch = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.completeopt:append('menuone,noselect,popup,fuzzy')
opt.complete = 'o,.,w,b,u,t'
opt.pumborder = 'rounded'
opt.pumblend = 10
opt.foldlevelstart = 99

local config_group = vim.api.nvim_create_augroup('config-pack-changed', { clear = true })

vim.api.nvim_create_autocmd('PackChanged', {
  group = config_group,
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    local function load_plugin()
      if not ev.data.active then
        vim.cmd.packadd(name)
      end
    end

    if name == 'nvim-treesitter' and kind == 'update' then
      load_plugin()
      vim.cmd([[TSUpdate]])
    end

    if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.pack.add({
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/yannvanhalewyn/jujutsu.nvim',
  'https://github.com/pwntester/octo.nvim',
  'https://github.com/tpope/vim-fugitive',

  -- Treesitter
  'https://github.com/nvim-treesitter/nvim-treesitter',

  -- LSP
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/onsails/lspkind.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mfussenegger/nvim-jdtls',
  'https://github.com/seblj/roslyn.nvim',
  'https://github.com/scalameta/nvim-metals',

  -- Formatting and linting
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',

  -- Colorschemes
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },

  -- Notifications
  'https://github.com/j-hui/fidget.nvim',

  -- Telescope
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
})

require('fidget').setup({})
vim.notify = require('fidget').notify

require('catppuccin').setup({
  flavour = 'mocha',
})

vim.cmd.colorscheme('catppuccin')

require('lazydev').setup({
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})
