-- these settings get automatically applied to the "lua_ls" LSP
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        -- warn the LSP disgnostic about the undefined global "vim" so that
        -- we don't see a million warnings in our vim config files
        globals = { "vim" }
      }
    }
  }
})

