---@type LazySpec[]
return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup {}

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      for idx, key in ipairs { 'j', 'k', 'l', ';' } do
        vim.keymap.set('n', string.format('<space>%s', key), function()
          harpoon:list():select(idx)
        end, {
          desc = 'Harpoon select ' .. idx,
        })
      end
    end,
  },
}
