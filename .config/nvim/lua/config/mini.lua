require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
require('mini.bracketed').setup()

local statusline = require 'mini.statusline'

local diag_signs = {
  ERROR = '%#MiniStatuslineDiagnosticError#',
  WARN = '%#MiniStatuslineDiagnosticWarn#',
  INFO = '%#MiniStatuslineDiagnosticInfo#󰋼',
  HINT = '%#MiniStatuslineDiagnosticHint#',
}

local devinfo_highlight = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineDevinfo' })
for _, diag_kind in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
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
  local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
  local git = statusline.section_git { trunc_width = 40 }
  local diff = statusline.section_diff { trunc_width = 75 }
  local lsp = statusline.section_lsp { trunc_width = 75 }
  local filename = '%f%m%r'
  local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
  local location = '%l:%-2v'
  local search = statusline.section_searchcount { trunc_width = 75 }

  local diagnostics = statusline.section_diagnostics { trunc_width = 75, signs = diag_signs }
  diagnostics = diagnostics .. '%#MiniStatuslineDevinfo#'

  return statusline.combine_groups {
    { hl = mode_hl, strings = { mode } },
    { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    -- vim.fn.mode() ~= 't' and symbols.has() and symbols.get() or '',
    '%=', -- End left alignment
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    { hl = mode_hl, strings = { search, location } },
  }
end

statusline.setup {
  use_icons = vim.g.have_nerd_font,
  content = {
    active = vim.g.have_nerd_font and statusline_config or nil,
  },
}
