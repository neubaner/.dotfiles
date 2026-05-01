require('mini.bracketed').setup()
require('mini.diff').setup()
require('mini.ai').setup()
require('mini.surround').setup()

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = { 'n', 'x' }, keys = '<Leader>' },

    -- `[` and `]` keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = { 'n', 'x' }, keys = 'g' },

    -- Marks
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },

    -- Registers
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

local statusline = require('mini.statusline')

local diag_signs = {
  ERROR = '%#MiniStatuslineDiagnosticError#',
  WARN = '%#MiniStatuslineDiagnosticWarn#',
  INFO = '%#MiniStatuslineDiagnosticInfo#󰋼',
  HINT = '%#MiniStatuslineDiagnosticHint#',
}

local devinfo_highlight = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineDevinfo' })
for _, diag_kind in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
  local diag_highlight = vim.api.nvim_get_hl(0, { name = 'Diagnostic' .. diag_kind })
  vim.api.nvim_set_hl(
    0,
    'MiniStatuslineDiagnostic' .. diag_kind,
    vim.tbl_extend('force', devinfo_highlight, {
      fg = diag_highlight.fg,
    })
  )
end

local function statusline_config()
  local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
  local git = statusline.section_git({ trunc_width = 40 })
  local diff = statusline.section_diff({ trunc_width = 75 })
  local lsp = statusline.section_lsp({ trunc_width = 75 })
  local filename = '%f%m%r'
  local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
  local location = '%l:%-2v'
  local search = statusline.section_searchcount({ trunc_width = 75 })

  local diagnostics = statusline.section_diagnostics({ trunc_width = 75, signs = diag_signs })
  diagnostics = diagnostics .. '%#MiniStatuslineDevinfo#'

  return statusline.combine_groups({
    { hl = mode_hl, strings = { mode } },
    { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    -- vim.fn.mode() ~= 't' and symbols.has() and symbols.get() or '',
    '%=', -- End left alignment
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    { hl = mode_hl, strings = { search, location } },
  })
end

statusline.setup({
  use_icons = vim.g.have_nerd_font,
  content = {
    active = vim.g.have_nerd_font and statusline_config or nil,
  },
})
