---@type LazySpec[]
return {
  {
    'rcarriga/nvim-notify',
    priority = 1000,
    init = function()
      vim.notify = require 'notify'
    end,
  },
}
