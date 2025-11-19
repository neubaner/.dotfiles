---@type LazySpec[]
return {
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat', 'CodeCompanionCmd', 'CodeCompanionHistory', 'CodeCompanionSummaries' },
    opts = function()
      return {
        memory = {
          opts = {
            chat = {
              enable = true,
            },
          },
        },
        display = {
          chat = {
            show_settings = false,
          },
        },
        strategies = {
          chat = {
            adapter = {
              name = 'copilot',
              model = 'claude-sonnet-4',
            },
          },
          inline = {
            adapter = 'copilot',
          },
        },
        extensions = {
          vectorcode = {
            opts = {
              tool_group = {
                enabled = true,
                collapse = false,
              },
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
          history = {
            enabled = true,
            ---@module 'codecompanion._extensions.history'
            ---@type CodeCompanion.History.Opts
            opts = {
              -- Keymap to open history from chat buffer (default: gh)
              keymap = 'gh',
              -- Save all chats by default (disable to save only manually using 'sc')
              auto_save = true,
              -- Number of days after which chats are automatically deleted (0 to disable)
              expiration_days = 0,
              -- Picker interface (auto resolved to a valid picker)
              picker = 'telescope', --- ("telescope", "snacks", "fzf-lua", or "default")
              -- Customize picker keymaps (optional)
              picker_keymaps = {
                rename = { n = 'r', i = '<M-r>' },
                delete = { n = 'd', i = '<M-d>' },
                duplicate = { n = '<C-y>', i = '<C-y>' },
              },
              ---Automatically generate titles for new chats
              auto_generate_title = true,
              ---On exiting and entering neovim, loads the last chat on opening chat
              continue_last_chat = false,
              ---When chat is cleared with `gx` delete the chat from history
              delete_on_clearing_chat = false,
              ---Directory path to save the chats
              dir_to_save = vim.fs.joinpath(vim.fn.stdpath 'data', 'codecompanion-history'),
              ---Enable detailed logging for history extension
              enable_logging = false,
              -- Summary system
              summary = {
                -- Keymap to generate summary for current chat (default: "gcs")
                create_summary_keymap = 'gcs',
                -- Keymap to browse summaries (default: "gbs")
                browse_summaries_keymap = 'gbs',

                generation_opts = {
                  adapter = nil, -- defaults to current chat adapter
                  model = nil, -- defaults to current chat model
                  context_size = 90000, -- max tokens that the model supports
                  include_references = true, -- include slash command content
                  include_tool_outputs = true, -- include tool execution results
                  system_prompt = nil, -- custom system prompt (string or function)
                  format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
                },
              },

              -- Memory system (requires VectorCode CLI)
              memory = {
                -- Automatically index summaries when they are generated
                auto_create_memories_on_summary_generation = true,
                -- Path to the VectorCode executable
                vectorcode_exe = 'vectorcode',
                -- Tool configuration
                tool_opts = {
                  -- Default number of memories to retrieve
                  default_num = 10,
                },
                -- Enable notifications for indexing progress
                notify = true,
                -- Index all existing memories on startup
                -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
                index_on_startup = false,
              },
            },
          },
        },
      }
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/codecompanion-history.nvim',
      {
        'Davidyz/VectorCode',
        version = '*', -- optional, depending on whether you're on nightly or release
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      {
        'ravitemer/mcphub.nvim',
        build = 'bundled_build.lua',
        dependencies = {
          'nvim-lua/plenary.nvim',
        },
        opts = {
          use_bundled_binary = true,
          auto_approve = false,
        },
      },
    },
  },
}
