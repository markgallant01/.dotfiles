-- configuration for LSP-related plugin group
return {
  -- mason-tool-installer is the top-level plugin. it requires the following
  -- plugins in the "dependencies" section to already be loaded for it to work.
  -- lazy ensures that any dependencies get loaded first.
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  lazy = false, -- this is necessary to ensure the plugin always loads
  config = function()
    require('mason-tool-installer').setup({
      -- these are the LSP servers that will be auto-installed if they're
      -- not already. Put anything you want to have on this list. the
      -- names can be from Mason's LSP server names, or from the
      -- nvim-lspconfig server name list. the mason-lspconfig plugin below
      -- ensures either name works. we typically use the names as they
      -- appear on nvim-lspconfig for consistency.
      ensure_installed = {
        "bashls",
        "clangd",
        "cssls",
        "dockerfile-language-server",
        "html",
        "jsonls",
        "lua_ls",
        "pyright",
        "ts_ls"
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

