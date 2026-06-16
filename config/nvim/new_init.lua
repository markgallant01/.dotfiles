-- Neovim options and basic settings
do
  -- cache lua modules for faster startup
  vim.loader.enable()

  -- set <space> as the leader key
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  vim.g.have_nerd_font = true

  vim.o.number = true
  vim.o.relativenumber = true

  vim.o.mouse = "a"

  vim.o.showmode = false

  -- sync clipboard with OS
  vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
  end)

  vim.o.breakindent = true
  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
  vim.o.expandtab = true

  vim.o.undofile = true

  -- case insensitive search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  vim.o.signcolumn = "yes"
  vim.o.colorcolumn = '80'

  vim.o.updatetime = 250
  vim.o.timeoutlen = 300

  -- live preview substitutions
  vim.o.inccommand = "split"

  vim.o.cursorline = true
  vim.o.guicursor = 'n-v-c-i:block'

  vim.o.scrolloff = 10
  vim.o.wrap = false

  vim.o.filetype = 'on'

  vim.o.termguicolors = true

  -- prompt to save file when trying to close with unsaved changes
  vim.o.confirm = true
end

-- keymaps
do
  -- [[ Basic Keymaps ]]
  -- See `:help vim.keymap.set()`

  -- clear highlights on search when pressing <Esc> in normal mode
  -- See `:help hlsearch`   
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

  -- diagnostic config and keymaps
  -- See `:help vim.diagnostic.Opts`
  vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = false, -- shows up at the end of the line
    virtual_lines = false, -- shows up underneath the line, with virtual lines

    -- auto open the float so you can easily read errors when jumping around
    -- with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float({
          bufnr = bufnr,
          scope = "cursor",
          focus = false,
        })
      end,
    },
  })

  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
end

