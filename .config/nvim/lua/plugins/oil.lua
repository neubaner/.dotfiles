---@type LazySpec[]
return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    ---@type oil.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      default_file_explorer = true,
      ---@diagnostic disable-next-line: missing-fields
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ['gg'] = {
          desc = 'Navigate down recursively',
          callback = function()
            local function get_leaf_path(parent)
              local children = {}
              for child in vim.fs.dir(parent) do
                table.insert(children, vim.fs.joinpath(parent, child))
              end

              if #children == 1 and vim.fn.isdirectory(children[1]) == 1 then
                return get_leaf_path(children[1])
              end

              return parent
            end

            local oil = require 'oil'
            local current_entry = oil.get_cursor_entry()

            if current_entry == nil or current_entry.type ~= 'directory' then
              oil.select()
            end

            local leaf_path = get_leaf_path(vim.fs.joinpath(oil.get_current_dir(), oil.get_cursor_entry().parsed_name))
            oil.open(leaf_path)
          end,
        },
        -- TODO: Navigate up recursively
        -- ['__'] = {
        --   desc = 'Navigate up recursively',
        --   callback = function()
        --     local function get_leaf_path(parent)
        --       local children = {}
        --       for child in vim.fs.dir(parent) do
        --         table.insert(children, vim.fs.joinpath(parent, child))
        --       end
        --
        --       if #children == 1 and vim.fn.isdirectory(children[1]) == 1 then
        --         return get_leaf_path(children[1])
        --       end
        --
        --       return parent
        --     end
        --
        --     local oil = require 'oil'
        --     local current_entry = oil.get_cursor_entry()
        --
        --     if current_entry == nil or current_entry.type ~= 'directory' then
        --       oil.select()
        --     end
        --
        --     local leaf_path = get_leaf_path(vim.fs.joinpath(oil.get_current_dir(), oil.get_cursor_entry().parsed_name))
        --     oil.open(leaf_path)
        --   end,
        -- },
      },
    },
    keys = {
      { '-', '<CMD>Oil<CR>', desc = 'Open parent directory', mode = 'n' },
      {
        '<leader>-',
        function()
          require('oil').toggle_float()
        end,
        desc = 'Open parent directory',
        mode = 'n',
      },
    },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
