-- ]]
-- Set <space> as the leader key
-- See ':help mapleader'
-- NOTE: Must happen before plugins are required (otherwise wrong
-- leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
-- https://github.com/folke/lazy.nvim
-- ':help lazy.nvim.txt' for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
-- You can configure plugins using the 'config' key.
-- You can also configure plugins after the setup call,
-- as they will be available in your neovim runtime.
require('lazy').setup({
  -- LSP Install
  -- configuration is down further down. search lspconfig.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: 'opts = {}' is the same as calling 'require('fidget').setup({})'
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  {
    -- Monokai theme
    'tanvirtin/monokai.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'monokai_pro'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See ':help lualine.txt'
    opts = {
      options = {
        icons_enabled = false,
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- Fuzzy Finder
  { 
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },

  -- Fuzzy Finder algorithm
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- autopairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {},
  },

}, {})

-- [[ setting options ]]
--
vim.o.guicursor = ""
vim.o.mouse = 'a'

vim.o.clipboard = 'unnamedplus'

vim.wo.nu = true
vim.o.relativenumber = true

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
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

vim.o.colorcolumn = "80"

vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
--
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- [[ Configure Telescope ]]
-- See ':help telescope' and ':help telescope.setup()'
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u'] = false,
        ['C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See ':help telescope.builtin'
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })

