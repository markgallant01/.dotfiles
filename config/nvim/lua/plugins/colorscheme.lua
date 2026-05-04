-- configuration for colorschemes

-- each colorscheme is defined as a table. at the bottom of the file, one
-- table is returned. This is the enabled colorscheme. To change colorschemes,
-- only change which table is returned at the very bottom.


-- configuration for solarized-osaka plugin
local solarized_osaka = {
  "craftzdog/solarized-osaka.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('solarized-osaka').setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings

      -- Enable this to disable setting the background color
      transparent = true,

      -- Configure the colors used when opening a `:terminal` in
      -- [Neovim](https://github.com/neovim/neovim)
      terminal_colors = true,

      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},

        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },

      -- Set a darker background on sidebar-like windows. For example:
      -- `["qf", "vista_kind", "terminal", "packer"]`
      sidebars = { "qf", "help" },

      -- Adjusts the brightness of the colors of the **Day** style. Number
      -- between 0 and 1, from dull to vibrant colors
      day_brightness = 0.3,

      -- Enabling this option, will hide inactive statuslines and replace them
      -- with a thin border instead. Should work with the standard
      -- **StatusLine** and **LuaLine**.
      hide_inactive_statusline = false,

      dim_inactive = false, -- dims inactive windows

      -- When `true`, section headers in the lualine theme will be bold
      lualine_bold = false,

      --- You can override specific color groups to use other groups
      --- or a hex color
      --- function will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors) end,

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      ---@param highlights Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors) end,
    })

    vim.cmd[[colorscheme solarized-osaka]]
  end,
}

-- enable chosen colorscheme here
return solarized_osaka

