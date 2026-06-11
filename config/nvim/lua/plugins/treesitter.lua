return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.config")

    configs.setup({
      -- list of parsers to install
      ensure_installed = {
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "lua",
        "python",
        "typescript",
        "vim",
        "vimdoc",
      },

      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
      }
    })
  end
}
