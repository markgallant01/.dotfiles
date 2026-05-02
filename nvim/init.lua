-- neovim init file
-- the entire setup is started from this file

-- pull in vim options before anything else so that things like keybinds
-- and leader keys are set for any plugins that might need them
require('config.vim_opts')

-- initialize lazy package manager. the package manager should then
-- load up the plugins defined and configured in the /lua/plugins/ folder
require('config.lazy')

-- load plugin keybinds after lazy so the plugins are loaded before binds
-- are set
require('config.plugin_keybinds')

-- load colorscheme. this happens here instead of in the colorscheme's config
-- file so that we could have multiple colorschemes installed and we can
-- just pick whichever one we want to load here
vim.cmd[[colorscheme solarized-osaka]]

