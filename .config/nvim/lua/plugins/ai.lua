local ollama_host = vim.env.OLLAMA_HOST or ''

local use_companion = true

---@type LazySpec[]
return {
  {
    'olimorris/codecompanion.nvim',
    enabled = use_companion,
    opts = function()
      return {
        display = {
          chat = {
            show_settings = true,
          },
        },
        strategies = {
          chat = {
            adapter = {
              name = 'copilot',
              model = 'claude-3.7-sonnet',
            },
          },
          inline = {
            adapter = 'copilot',
          },
        },
        extensions = {
          vectorcode = {
            opts = {
              add_tool = true,
            },
          },
          mcphub = {
            callback = 'mcphub.extensions.codecompanion',
            opts = {
              show_result_in_chat = true,
              make_vars = true,
              make_slash_commands = true,
            },
          },
        },
      }
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'Davidyz/VectorCode',
        version = '*', -- optional, depending on whether you're on nightly or release
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      {
        'ravitemer/mcphub.nvim',
        build = 'npm install -g mcp-hub@latest',
        opts = {},
      },
    },
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    enabled = not use_companion,
    version = false,
    opts = function()
      return {
        provider = 'copilot',
        providers = {
          copilot = {
            model = 'claude-3.7-sonnet',
          },
        },
        behaviour = {
          enable_token_counting = true,
        },
      }
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      { 'zbirenbaum/copilot.lua', opts = {} },
      --- The below dependencies are optional,
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
      'Kaiser-Yang/blink-cmp-avante',
    },
  },
}
