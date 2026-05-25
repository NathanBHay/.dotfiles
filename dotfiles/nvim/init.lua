do
  -- -- Faster Loading
  vim.loader.enable()

  -- Set <space> as the leader key
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- [[ Setting options ]]
  -- See `:help vim.opt`
  --  For more options, you can see `:help option-list`

  -- Make line numbers default
  vim.opt.number = true
  vim.opt.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.opt.mouse = 'a'

  -- Remove Mouse Popups
  vim.cmd.aunmenu { 'PopUp.How-to\\ disable\\ mouse' }
  vim.cmd.aunmenu { 'PopUp.-1-' }

  -- Don't show the mode, since it's already in status line
  vim.opt.showmode = false

  -- Sync the system clipboard with vim
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)

  -- Enable break indent
  vim.opt.breakindent = true

  -- Save undo history
  vim.opt.undofile = true

  -- Case-insensitive searching UNLESS \C or capital in search
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Keep signcolumn on by default
  vim.opt.signcolumn = 'yes'

  -- Decrease update time
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.opt.splitright = true
  vim.opt.splitbelow = true

  -- Sets how neovim will display certain whitespace in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  vim.opt.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.opt.inccommand = 'split'

  -- Show which line your cursor is on
  vim.opt.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.opt.scrolloff = 10

  vim.opt.winborder = 'rounded'

  -- Avoid folding by default
  vim.opt.foldlevel = 99

  -- Auto enable transparent background
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    desc = 'Transparent background',
    group = vim.api.nvim_create_augroup('kickstart-transparent-background', { clear = true }),
    callback = function()
      vim.cmd 'highlight Normal guibg=none'
      vim.cmd 'highlight NonText guibg=none'
    end,
  })

  -- Automatically enable spell checking for markdown files
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'tex' },
    desc = 'Enable spell checking for markdown files',
    group = vim.api.nvim_create_augroup('auto-spell-check', { clear = true }),
    callback = function()
      vim.opt.spell = true
    end,
  })

  -- [[ Basic Keymaps ]]

  -- Set highlight on search, but clear on pressing <Esc> in normal mode
  vim.opt.hlsearch = true
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  vim.keymap.set('i', '<C-BS>', '<C-W>', { desc = 'Delete backwards word' })
  vim.keymap.set('i', '<C-DEL>', '<C-o>dw', { desc = 'Delete forwards word' })

  -- Keybinds to make split navigation easier.
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Highlight when yanking (copying) text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })
end

do
  function GH(repo)
    return 'https://github.com/' .. repo
  end

  vim.pack.add { GH 'folke/which-key.nvim' }
  require('which-key').setup {
    preset = 'helix',
    spec = {
      { 'gs', group = '[S]urround', mode = { 'n', 'v' } },
      { '<leader>l', group = '[L]azyGit', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggleables', mode = { 'n', 'v' } },
    },
  }

  vim.pack.add { GH 'catppuccin/nvim' }
  require('catppuccin').setup()
  vim.cmd.colorscheme 'catppuccin'
  vim.cmd.hi 'Comment gui=none' -- TODO: Check what this does

  vim.pack.add { GH 'nvim-lualine/lualine.nvim' }
  require('lualine').setup { theme = 'catppuccin' }

  -- Highlight todo, notes, perf, hack, fix, warning
  vim.pack.add {
    GH 'nvim-lua/plenary.nvim', -- Also used in telescope & lazygit.
    GH 'folke/todo-comments.nvim',
    GH 'kdheepak/lazygit.nvim',
  }
  require('todo-comments').setup { signs = false }

  -- Open lazygit in a floating window
  vim.keymap.set('n', '<leader>l', '<cmd>LazyGit<CR>', { desc = '[L]azyGit', silent = true })

  require 'editor'
  require 'lsp'
  require 'navigation'
  require 'treesitter'
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
