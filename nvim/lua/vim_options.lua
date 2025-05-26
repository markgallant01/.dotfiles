-- ]]
-- Set <space> as the leader key
-- See ':help mapleader'
-- NOTE: Must happen before plugins are required (otherwise wrong
-- leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.guicursor = ""
vim.o.mouse = 'a'
vim.o.mousemodel = 'extend'

vim.o.clipboard = 'unnamedplus'

vim.wo.nu = true
vim.o.relativenumber = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.smartindent = true
vim.o.breakindent = true

vim.o.wrap = false

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.termguicolors = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"

vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.o.colorcolumn = "73"
-- vim.o.foldmethod = 'indent'

-- disable automatic commenting newline
vim.cmd("autocmd FileType * set formatoptions-=ro")

-- open all folds by default
vim.cmd("autocmd BufRead * normal zR")

-- [[Diagnostic Config]]
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = ''
    },
    lineh1 = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignWarn'
    }
  }
})

