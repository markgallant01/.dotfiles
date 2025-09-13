-- Set <space> as the leader key
-- See `:help mapleader`
-- Note: this must happen before plugins are loaded so they use the correct
-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- set to true if you have a Nerd Font installed and set in the temrinal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.o`
-- For more options see `:help options-list`

-- Make line numbers default
vim.o.number = true

-- Add relative line numbers
vim.o.relativenumber = true

-- Don't show the mode since it's in the status line
vim.o.showmode = false

-- Sync OS clipboard with Neovim
-- See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching unless capital letters in search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Live preview substitutions
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimum number of lines to keep above and below cursor
vim.o.scrolloff = 10

-- Confirm before quitting without saving
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

