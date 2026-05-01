local metals = require('metals')
local metals_config = metals.bare_config()

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scala', 'sbt' },
  callback = function()
    metals.initialize_or_attach(metals_config)
  end,
})
