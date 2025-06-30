---@type LazySpec[]
return {
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup {
        notify_on_error = false,
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          local disable_filetypes = { c = true, cpp = true, razor = true }
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
          -- java = { 'spotless' },
          ['terraform-vars'] = { 'hcl' },
        },
        log_level = vim.log.levels.DEBUG,
        formatters = {
          spotless = {
            condition = function(_, ctx)
              return vim.bo[ctx.buf].filetype == 'java'
            end,
            cwd = require('conform.util').root_file { '.git', 'mvnw', 'gradlew' },
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
            require_cwd = true,
            stdin = true,
          },
        },
      }
      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })

      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
    end,
  },
  { 'NMAC427/guess-indent.nvim', opts = {} },
}
