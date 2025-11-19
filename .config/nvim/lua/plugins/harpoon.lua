---@type LazySpec[]
return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    opts = {},
    keys = function()
      local keymaps = {
        {
          '<leader>a',
          function()
            require('harpoon'):list():add()
          end,
          mode = { 'n' },
          desc = 'Harpoon push current buffer',
        },
        {
          '<C-e>',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          mode = { 'n' },
          desc = 'Harpoon push current buffer',
        },
      }

      for idx, key in ipairs { 'j', 'k', 'l', ';' } do
        table.insert(keymaps, {
          string.format('<leader>%s', key),
          function()
            local harpoon = require 'harpoon'
            harpoon:list():select(idx)
          end,
          mode = { 'n' },
          desc = 'Harpoon select ' .. idx,
        })
      end

      return keymaps
    end,
  },
}
