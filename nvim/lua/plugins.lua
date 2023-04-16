-- plugins table
return {
	{
		-- telescope fuzzy finder
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		-- tokyonight colorscheme
		'folke/tokyonight.nvim'
	},
	{
        -- treesitter parser
		"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"
	},
	{
        -- this is everything needed for LSP via LSP-Zero
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
				'williamboman/mason.nvim',
		      		build = function()
					pcall(vim.cmd, 'MasonUpdate')
		      		end,
		    	},
		    	{'williamboman/mason-lspconfig.nvim'}, -- Optional

		    	-- Autocompletion
		    	{'hrsh7th/nvim-cmp'},     -- Required
		    	{'hrsh7th/cmp-nvim-lsp'}, -- Required
		    	{'L3MON4D3/LuaSnip'},     -- Required
		}
	},
    {
        -- lualine statusbar
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    {
        -- lualine progress bar for LSP activity
        'arkav/lualine-lsp-progress'
    },
    {
        -- indentation guide lines
        "lukas-reineke/indent-blankline.nvim"
    },
    {
        -- autopairs for brackets and such
        "windwp/nvim-autopairs"
    },
}

