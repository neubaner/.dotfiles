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
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Run latest test',
      },
      {
        '<leader>tn',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run nearest test',
      },
      {
        '<leader>ta',
        function()
          require('neotest').run.run { suite = true }
        end,
        desc = 'Run all tests',
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Rune file tests',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run { strategy = 'dap', suite = false }
        end,
        desc = 'Debug nearest test',
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
