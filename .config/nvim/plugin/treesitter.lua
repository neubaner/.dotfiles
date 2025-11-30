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
    vim.bo[buf].indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
  end,
})
