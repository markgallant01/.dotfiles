-- these settings get automatically applied to the "lua_ls" LSP
return {
  settings = {
    Lua = {
      diagnostics = {
        disable = { "lowercase-global" },
        -- warn the LSP disgnostic about the undefined global "vim" so that
        -- we don't see a million warnings in our vim config files
        globals = { "vim" }
      }
    }
  }
}

