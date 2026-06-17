-- [[ Neovim ]]
-- For information about how Neovim integrates Lua:
-- `:help lua-guide`
-- or
-- https://neovim.io/doc/user/lua-guide.html

-- for general Vim / Neovim learning:
-- `:Tutor` is a general Vim / Neovim tutor
-- `:help` is the Neovim help docs
-- `<space>sh` [s]earches the [h]elp documentation

-- For configuration info:
-- `:checkhealth`

-- [[ SECTION 1: OPTIONS ]]
-- Core Neovim settings, leaders, options, basic keymaps & autocmds
do
  -- cache lua modules for faster startup
  vim.loader.enable()

  -- set <space> as the leader key
  -- Note: this has to happen before any plugins are loaded so that plugins
  -- use the correct leader key
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  vim.g.have_nerd_font = true

  -- [[ Options ]]
  -- See `:help vim.o`
  -- for options list `:help options-list`

  vim.o.number = true
  vim.o.relativenumber = true

  vim.o.mouse = "a"

  vim.o.showmode = false

  -- sync clipboard with OS
  -- See `:help "clipboard"`
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
  -- See `:help "confirm"`
  vim.o.confirm = true
end

-- [[ SECTION 2: KEYMAPS ]]
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

  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist,
    { desc = "Open diagnostic [Q]uickfix list" })

  -- Keybinds to make split navigation easier
  --  CTRL+<hjkl> to jump between split windows
  -- See `:help wincmd`
  vim.keymap.set("n", "<C-h>", "<C-w><C-h>",
    { desc = "Move focus to left window" })

  vim.keymap.set("n", "<C-l>", "<C-w><C-l>",
    { desc = "Move focus to right window" })

  vim.keymap.set("n", "<C-j>", "<C-w><C-j>",
    { desc = "Move focus to lower window" })

  vim.keymap.set("n", "<C-k>", "<C-w><C-k>",
    { desc = "Move focus to upper window" })

  -- [[ Basic Autocmds ]]
  -- See `:help lua-guide-autocommands`

  -- highlight when yanking text
  -- See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank",
      { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end

-- [[ SECTION 3: PLUGIN MANAGER ]]
-- vim.pack & build hooks
do
  -- See `:help vim.pack`
  -- and `:help vim.pack-examples`
  -- https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack

  -- to check plugin state and check for updates:
  --  `:lua vim.pack.update(nil, { offline = true })`

  -- to update plugins:
  --  `:lua vim.pack.update()`

  -- [[ autocmds ]]
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ""
      local stdout = result.stdout or ""
      local output = stderr ~= "" and stderr or stdout
      if output == "" then output = "No output from build command." end
      vim.notify(("Build failed for %s:\n%s"):format(name, output),
        vim.log.levels.ERROR)
    end
  end

  -- This autocmd runs after a plugin is installed or updated and runs the
  -- appropriate build command for that plugin if necessary
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= "install" and kind ~= "update" then return end

      if name == "telescope-fzf-native.nvim" and
        vim.fn.executable("make") == 1 then
        run_build(name, { "make" }, ev.data.path)
        return
    end

    if name == "LuaSnip" then
      if vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
        run_build(name, { "make", "install_jsregexp" }, ev.data.path) end
      return
    end

    if name == "nvim-treesitter" then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
      return
    end
  end
  })
end
