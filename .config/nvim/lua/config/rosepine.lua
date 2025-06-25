require('rose-pine').setup {
  styles = {
    italic = false,
  },
  highlight_groups = {
    ['@interface'] = {
      fg = 'leaf',
      bold = true,
      italic = true,
    },
    ['@type'] = {
      fg = 'leaf',
      bold = true,
    },
    ['@type.builtin'] = {
      fg = 'love',
    },
    ['@lsp.type.modifier.java'] = {
      link = '@keyword',
    },
    ['@lsp.type.namespace'] = {
      link = 'Directory',
    },
    NotifyBackground = {
      fg = 'overlay',
    },
  },
}
vim.cmd.colorscheme 'rose-pine-main'
