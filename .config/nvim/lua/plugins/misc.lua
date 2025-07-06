---@type LazySpec[]
return {
  { 'brenoprata10/nvim-highlight-colors', opts = {} },
  { 'xiyaowong/transparent.nvim', opts = {} },
  {
    'kndndrj/nvim-dbee',
    dependencies = { 'MunifTanjim/nui.nvim' },
    build = function()
      require('dbee').install()
    end,
    opts = {},
  },
}
