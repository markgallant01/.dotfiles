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
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of 
      -- `.git/` as it's not `.gitignore`d.
		  find_command = {
        "rg",
        "--files",
        "--hidden",
        "--glob",
        "!**/.git/*"
      },
    }
  }
}

-- Enable telescope fzf native, if installed
-- NOTE: must come after setup function
require('telescope').load_extension('fzf')

