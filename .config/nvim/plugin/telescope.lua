local telescope = require('telescope')

telescope.setup({
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
})

telescope.load_extension('fzf')
telescope.load_extension('ui-select')
