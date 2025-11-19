---@type LazySpec[]
return {
  { 'brenoprata10/nvim-highlight-colors', opts = {} },
  { 'xiyaowong/transparent.nvim', opts = {} },
  {
    'kndndrj/nvim-dbee',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'Dbee',
    build = function()
      require('dbee').install()
    end,
    opts = {},
  },
}
