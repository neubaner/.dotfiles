local M = {}

function M.invert_highlight(highlight_name)
  local highlight = vim.api.nvim_get_hl(0, { name = highlight_name })
  local inverted_highlight = vim.tbl_extend('keep', { fg = highlight.bg, bg = highlight.fg }, highlight)

  vim.api.nvim_set_hl(0, highlight_name .. 'Inverted', inverted_highlight)
end

function M.combine_groups(groups)
  local parts = vim.tbl_map(function(s)
    if type(s) == 'string' then
      return s
    end
    if type(s) ~= 'table' then
      return ''
    end

    local string_arr = vim.tbl_filter(function(x)
      return type(x) == 'string' and x ~= ''
    end, s.strings or {})
    local str = table.concat(string_arr, ' ')
    local use_spaces = s.spaces == true or s.spaces == nil

    -- Use previous highlight group
    if s.hl == nil then
      if use_spaces then
        return ' ' .. str .. ' '
      else
        return str
      end
    end

    -- Allow using this highlight group later
    if str:len() == 0 then
      return '%#' .. s.hl .. '#'
    end

    if use_spaces then
      return string.format('%%#%s# %s ', s.hl, str)
    else
      return string.format('%%#%s#%s', s.hl, str)
    end
  end, groups)

  return table.concat(parts, '')
end

return M
