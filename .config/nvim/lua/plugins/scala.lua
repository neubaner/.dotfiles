---@type LazySpec[]

return {
  {
    'scalameta/nvim-metals',
    ft = { 'scala', 'sbt' },
    opts = function()
      local config = require('metals').bare_config()
      config.init_options.statusBarProvider = 'off'

      return config
    end,
    config = function(self, opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = self.ft,
        group = vim.api.nvim_create_augroup('nvim-metals', { clear = true }),
        callback = function()
          require('metals').initialize_or_attach(opts)
        end,
      })
    end,
  },
}
