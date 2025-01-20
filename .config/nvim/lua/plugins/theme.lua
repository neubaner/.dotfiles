---@type LazySpec[]
return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'tokyonight-moon'
      vim.cmd.hi 'Comment gui=none'
    end,
    config = function()
      require('tokyonight').setup {
        on_highlights = function(highlights, colors)
          highlights.LspCodeLens = { fg = colors.comment }
        end,
      }
    end,
  },
  {
    'AlexvZyl/nordic.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('nordic').load()
    end,
  },
  {
    'ramojus/mellifluous.nvim',
    enabled = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('mellifluous').setup {}
      vim.cmd 'colorscheme mellifluous'
    end,
  },
  {
    'ficcdaf/ashen.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'ashen'
      require('ashen').load()
    end,
    opts = {},
  },
}
