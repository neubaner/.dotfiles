local keymap = vim.keymap

-- Oil
keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
keymap.set('n', '<leader>-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory in a floating window' })

-- Diagnostics
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
keymap.set('n', '<leader>Q', vim.diagnostic.setqflist, { desc = 'Open all diagnostics [Q]uickfix list' })

-- Window
keymap.set('n', '<M-,>', '<C-w>5<', { desc = 'Decrease window width by 5' })
keymap.set('n', '<M-.>', '<C-w>5>', { desc = 'Increase window width by 5' })
keymap.set('n', '<M-t>', '<C-w>5+', { desc = 'Increase window height by 5' })
keymap.set('n', '<M-s>', '<C-w>5-', { desc = 'Decrease window height by 5' })

keymap.set('n', 'K', function()
  vim.lsp.buf.hover({
    border = 'rounded',
  })
end)

-- Terminal
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Telescope
local tl = require('telescope.builtin')
keymap.set('n', '<leader>sh', tl.help_tags, { desc = '[S]earch [H]elp' })
keymap.set('n', '<leader>sk', tl.keymaps, { desc = '[S]earch [K]eymaps' })
keymap.set('n', '<leader>sf', tl.find_files, { desc = '[S]earch [F]iles' })
keymap.set('n', '<leader>gf', tl.git_files, { desc = 'Search [G]it [F]iles' })
keymap.set('n', '<leader>ss', tl.builtin, { desc = '[S]earch [S]elect Telescope' })
keymap.set('n', '<leader>sw', tl.grep_string, { desc = '[S]earch current [W]ord' })
keymap.set('n', '<leader>sg', tl.live_grep, { desc = '[S]earch by [G]rep' })
keymap.set('n', '<leader>sd', tl.diagnostics, { desc = '[S]earch [D]iagnostics' })
keymap.set('n', '<leader>sr', tl.resume, { desc = '[S]earch [R]esume' })
keymap.set('n', '<leader>s.', tl.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
keymap.set('n', '<leader><leader>', tl.buffers, { desc = '[ ] Find existing buffers' })
keymap.set('n', '<leader>sb', tl.git_branches, { desc = '[ ] Find existing buffers' })

keymap.set('n', '<leader>/', function()
  tl.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = '[/] Fuzzily search in current buffer' })

keymap.set('n', '<leader>s/', function()
  tl.live_grep({
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  })
end, { desc = '[S]earch [/] in Open Files' })

keymap.set('n', '<leader>sn', function()
  tl.find_files({ cwd = vim.fn.stdpath('config') })
end, { desc = '[S]earch [N]eovim files' })
