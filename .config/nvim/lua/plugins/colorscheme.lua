---@type LazySpec[]
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
      }
    end,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      on_highlights = function(highlights, colors)
        highlights.LspCodeLens = { fg = colors.comment }
      end,
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd [[colorscheme tokyonight-night]]
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'vague2k/vague.nvim',
    lazy = true,
    priority = 1000,
  },
}
