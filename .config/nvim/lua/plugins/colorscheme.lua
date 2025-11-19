---@type LazySpec[]
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    ---@module 'catppuccin'
    ---@type CatppuccinOptions
    opts = {
      flavour = 'mocha',
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    opts = {
      on_highlights = function(highlights, colors)
        highlights.LspCodeLens = { fg = colors.comment }
      end,
    },
    -- config = function(_, opts)
    --   require('tokyonight').setup(opts)
    --   vim.cmd [[colorscheme tokyonight-night]]
    --   vim.cmd.hi 'Comment gui=none'
    -- end,
  },
  {
    'vague2k/vague.nvim',
    lazy = true,
  },
}
