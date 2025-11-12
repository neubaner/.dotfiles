---@type LazySpec[]
return {
  {
    'rest-nvim/rest.nvim',
    enabled = false,
    keys = {
      {
        '<leader>r',
        ft = 'http',
        desc = 'Run HTTP Request',
        mode = { 'n' },
        function()
          vim.cmd [[Rest run]]
        end,
      },
    },
    ft = { 'http' },
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'json' },
        callback = function()
          vim.api.nvim_set_option_value('formatprg', 'jq', { scope = 'local' })
        end,
      })
    end,
    dependencies = {
      'nvim-treessiter/nvim-treesitter',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'http')
      end,
    },
  },
}
