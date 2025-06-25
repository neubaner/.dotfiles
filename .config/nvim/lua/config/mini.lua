require('mini.icons').setup {}
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
require('mini.bracketed').setup()

local mini_utils = require 'config.mini-utils'
local statusline = require 'mini.statusline'

local diag_signs = {
  ERROR = '%#DiagnosticError#',
  WARN = '%#DiagnosticWarn#',
  INFO = '%#DiagnosticInfo#󰋼',
  HINT = '%#DiagnosticHint#',
}

local symbols = require('trouble').statusline {
  mode = 'lsp_document_symbols',
  groups = {},
  title = false,
  filter = { range = true },
  format = '{kind_icon}{symbol.name:Normal}',
  hl_group = 'MiniStatuslineDevinfo',
}

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
