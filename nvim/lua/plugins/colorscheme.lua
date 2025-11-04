return {
  -- add solarized-osaka colorscheme
  { "craftzdog/solarized-osaka.nvim" },

  -- configure LazyVim to load solarized-osaka
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
}
