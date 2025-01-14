---@type LazySpec[]
return {
  {
    'stevearc/conform.nvim',
    opts = function()
      return {
        notify_on_error = false,
        format_on_save = function(bufnr)
          local disable_filetypes = { c = true, cpp = true, razor = true, java = false }
          return {
            timeout_ms = 5000,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          proto = { 'buf' },
          hcl = { 'hcl' },
          markdown = { 'markdownlint' },
          terraform = { 'hcl' },
          php = { 'pint' },
          java = { 'spotless' },
          ['terraform-vars'] = { 'hcl' },
        },
        log_level = vim.log.levels.DEBUG,
        formatters = {
          spotless = {
            condition = function(_, ctx)
              return vim.bo[ctx.buf].filetype == 'java'
            end,
            cwd = vim.print(require('conform.util').root_file { '.git', 'mvnw', 'gradlew' }),
            command = './gradlew',
            args = function(_, ctx)
              return {
                'spotlessApply',
                '--quiet',
                '-PspotlessIdeHook=' .. ctx.filename,
                '-PspotlessIdeHookUseStdIn',
                '-PspotlessIdeHookUseStdOut',
              }
            end,
            stdin = true,
          },
        },
      }
    end,
  },
  { 'tpope/vim-sleuth', enabled = true }, -- Detect tabstop and shiftwidth automatically
}
