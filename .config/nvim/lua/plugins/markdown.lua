local markdown_filetypes = { 'markdown', 'Avante', 'codecompanion' }

---@type LazySpec[]
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = markdown_filetypes,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = markdown_filetypes,
    },
  },
  {
    'OXY2DEV/markview.nvim',
    enabled = false,
    ft = { 'Avante', 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      preview = {
        filetypes = { 'Avante', 'markdown' },
      },
    },
  },
}
