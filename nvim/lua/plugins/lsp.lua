return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  lazy = false,
  config = function()
    require('mason-tool-installer').setup({
      ensure_installed = {
        "bashls",
        "clangd",
        "cssls",
        "deno",
        "dockerfile-language-server",
        "html",
        "jsonls",
        "lua_ls",
        "pyright",
      },
      run_on_start = true
    })
  end,
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    { "neovim/nvim-lspconfig" },
    { "mason-org/mason-lspconfig.nvim", opts = {} }
  }
}

