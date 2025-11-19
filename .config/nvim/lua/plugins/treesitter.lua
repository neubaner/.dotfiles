---@type LazySpec[]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
    },
    build = ':TSUpdate',
  },
}
