-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- [[ telescope ]]
-- See ':help telescope.builtin'
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
  { desc = '[?] Find recently opened files' })

vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
  { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files,
  { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string,
  { desc = '[S]earch current [W]ord' })

vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep,
  { desc = '[S]earch by [G]rep' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
  { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
  { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>w', vim.diagnostic.open_float,
  { desc = 'Open floating diagnostic message' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
  { desc = 'Open diagnostics list' })
