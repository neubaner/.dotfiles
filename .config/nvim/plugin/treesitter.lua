require('nvim-treesitter').install {
  -- Programming languages
  'lua',
  'c',
  'cpp',
  'c_sharp',
  'java',
  'javascript',
  'typescript',
  'terraform',
  'nix',
  'sql',
  'dockerfile',
  'proto',
  'php',

  -- Markup languages
  'toml',
  'json',
  'yaml',
  'markdown',
  'html',
  'css',

  -- Shell and similar
  'git_config',
  'make',
  'zsh',
  'bash',
  'sh',
  'tmux',
  'ssh_config',
}

---@param lang string
---@param query_group string
---@return boolean
local function supports_query_group(lang, query_group)
  local ok, query = pcall(vim.treesitter.query.get, lang, query_group)
  return ok and query ~= nil
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-setup', { clear = true }),
  callback = function(args)
    local buf = args.buf
    local filetype = args.match

    local language = vim.treesitter.language.get_lang(filetype) or filetype
    if not vim.treesitter.language.add(language) then
      return
    end

    vim.treesitter.start(buf, language)

    if supports_query_group(language, 'indent') then
      vim.bo[buf].indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
    end
  end,
})
