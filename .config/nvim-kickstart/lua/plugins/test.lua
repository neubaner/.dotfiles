---@type LazySpec[]
return {
  {
    'nvim-neotest/neotest',
    lazy = false,
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'rcasia/neotest-java',
      'Issafalcon/neotest-dotnet',
    },
    keys = {
      {
        '<leader>tt',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Run latest test',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run { strategy = 'dap', suite = false }
        end,
        desc = 'Run latest test',
      },
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-dotnet' {
            discovery_root = 'solution',
          },
          require 'neotest-java' {},
        },
      }
    end,
  },
}
