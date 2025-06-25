---@type LazySpec[]
return {
  {
    'GustavEikaas/easy-dotnet.nvim',
    ft = 'cs',
    enabled = false,
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
}
