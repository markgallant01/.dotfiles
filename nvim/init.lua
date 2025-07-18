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
  {
    -- default LSP configs
    'neovim/nvim-lspconfig'
  },

  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets'
    },
    version = '1.*'
  },

  {
    -- colorschemes
    'navarasu/onedark.nvim',
    'loctvl842/monokai-pro.nvim',
    { 'catppuccin/nvim', name = 'catppuccin' },
    'craftzdog/solarized-osaka.nvim',
    'AlphaTechnolog/pywal.nvim',
    lazy = false,
    priority = 1000,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
  },

  {
    -- bufferline
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
  },

  {
    -- telescope fuzzy finder
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      },
      {
        'nvim-tree/nvim-web-devicons',
        opts = {}
      },
    }
  },

  {
    -- treesitter
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    -- autopairs
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {},
  },

  {
    -- html auto tags
    'windwp/nvim-ts-autotag',
  },

  {
    -- scope and indent lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },

  {
    'echasnovski/mini.trailspace',
    version = '*'
  }
}, {})

-- setup my stuff
require('colorscheme')
require('vim_options')

-- plugins
require('plugins/lualine')
require('plugins/treesitter')
require('plugins/telescope')
require('plugins/autotag')
require('plugins/blink')
require('plugins/indent-blankline')
require('plugins/bufferline')
require('plugins/trailspace')

-- LSP servers
vim.lsp.enable('pyright')
vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')

-- keymaps last because they need access to plugins
require('keymaps')

