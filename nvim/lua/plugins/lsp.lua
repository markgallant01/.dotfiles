return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  lazy = false,
  config = function()
    require('mason-tool-installer').setup({
      ensure_installed = {
        "lua-language-server",
        "clangd"
      },
      run_on_start = true
    })
  end,
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    { "neovim/nvim-lspconfig" },
    { "mason-org/mason-lspconfig.nvim" }
  }
}

