-- this file sets up plugin keybinds.
-- it will be loaded after lazy loads the plugins.

-- bufferline
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>',
  { desc = 'Next buffer' } )

vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>',
  { desc = 'Previous buffer' } )

-- telescope
-- See `:help telescope.builtin`
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files,
  { desc = 'Telescope search files' })

vim.keymap.set('n', '<leader>sg', builtin.live_grep,
  { desc = 'Telescope live grep' })

vim.keymap.set('n', '<leader>sb', builtin.buffers,
  { desc = 'Telescope buffers' })

vim.keymap.set('n', '<leader>sh', builtin.help_tags,
  { desc = 'Telescope help tags' })

-- these are kickstart's keybinds which we might prefer.
--[[
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
--]]

