---@type LazySpec
return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts_extend = { 'spec' },
    ---@type wk.Opts
    opts = {
      preset = 'helix',
      spec = {
        {
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
        },
      },
    },
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
}
