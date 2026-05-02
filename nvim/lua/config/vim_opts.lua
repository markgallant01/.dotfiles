-- this file sets basic options for vim settings and some keybinds
-- for the built in vim stuff.
-- This is not the place for plugin keybinds or plugin options. This file
-- is loaded before any plugins.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'
vim.o.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.colorcolumn = '80'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.cursorline = true
vim.o.guicursor = 'n-v-c-i:block'

vim.o.scrolloff = 10
vim.o.wrap = false

vim.o.filetype = 'on'

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = false, -- shows up at the end of the line
  virtual_lines = false, -- shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with
  -- `[d` and `]d`
  jump = { float = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '',
      [vim.diagnostic.severity.INFO] = ''
    }
  }
}

-- Diagnostic keybinds
vim.keymap.set('n', '<leader>w', vim.diagnostic.open_float,
  { desc = 'Open diagnostic floating [W]indow' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>',
  { desc = 'Move focus to the left window' })

vim.keymap.set('n', '<C-l>', '<C-w><C-l>',
  { desc = 'Move focus to the right window' })

vim.keymap.set('n', '<C-j>', '<C-w><C-j>',
  { desc = 'Move focus to the lower window' })

vim.keymap.set('n', '<C-k>', '<C-w><C-k>',
  { desc = 'Move focus to the upper window' })

