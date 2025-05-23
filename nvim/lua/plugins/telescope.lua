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
-- NOTE: must come after setup function
require('telescope').load_extension('fzf')

