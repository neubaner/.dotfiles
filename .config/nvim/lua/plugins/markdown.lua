local markdown_filetypes = { 'markdown', 'codecompanion' }

---@type LazySpec[]
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = markdown_filetypes,
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = markdown_filetypes,
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
}
