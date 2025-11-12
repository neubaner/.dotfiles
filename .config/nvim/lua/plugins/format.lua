local state = {
  spotless_exists = {},
}

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

          local disable_filetypes = { c = true, cpp = true, razor = true, kotlin = true }

          return {
            timeout_ms = 10000,
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
          java = { 'spotless', lsp_format = 'fallback' },
          ['terraform-vars'] = { 'hcl' },
        },
        log_level = vim.log.levels.DEBUG,
        formatters = {
          spotless = {
            cwd = require('conform.util').root_file { '.git', 'mvnw', 'gradlew' },
            condition = function(self, ctx)
              local cwd = self:cwd(ctx)

              if cwd == nil then
                return false
              end

              if state.spotless_exists[cwd] == nil then
                local success, out = pcall(function()
                  return vim
                    .system({
                      './gradlew',
                      'spotlessCheck',
                      '--dry-run',
                    }, { cwd = cwd, text = true })
                    :wait()
                end)

                state.spotless_exists[cwd] = success and out.code == 0
              end

              return state.spotless_exists[cwd]
            end,
            format = function(self, ctx, lines, callback)
              vim.system({
                './gradlew',
                'spotlessApply',
                '--quiet',
                '--daemon',
                '--configuration-cache',
                '-PspotlessIdeHook=' .. ctx.filename,
                '-PspotlessIdeHookUseStdIn',
                '-PspotlessIdeHookUseStdOut',
              }, {
                cwd = require('conform.util').root_file { '.git', 'mvnw', 'gradlew' }(self, ctx),
                text = true,
                stdin = lines,
              }, function(out)
                vim.schedule(function()
                  if vim.startswith(out.stderr, 'IS DIRTY') then
                    local new_lines = vim.split(out.stdout, '\n', { plain = true })
                    while #new_lines > 0 and new_lines[#new_lines] == '' do
                      table.remove(new_lines)
                    end
                    callback(nil, new_lines)
                  elseif vim.startswith(out.stderr, 'IS CLEAN') then
                    callback(nil, lines)
                  elseif vim.startswith(out.stderr, 'DID NOT CONVERGE') then
                    callback(out.stderr, nil)
                  elseif out.stderr == '' then
                    callback('File not included in the formatter', nil)
                  else
                    callback(out.stderr, nil)
                  end
                end)
              end)
            end,
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
