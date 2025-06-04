-- Functions that enable navigation between files and buffers
return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    deendencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires special font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
        },
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Search [H]elp' })
      vim.keymap.set('n', '<leader>k', builtin.keymaps, { desc = 'Search [K]eymaps' })
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Search [F]iles' })
      vim.keymap.set('n', '<leader>s', builtin.builtin, { desc = 'Search [S]elect Telescope' })
      vim.keymap.set('n', '<leader>w', builtin.grep_string, { desc = 'Search current [W]ord' })
      vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Search by [G]rep' })
      vim.keymap.set('n', '<leader>d', builtin.diagnostics, { desc = 'Search [D]iagnostics' })
      vim.keymap.set('n', '<leader>F', builtin.resume, { desc = 'Search [R]esume' })
      vim.keymap.set('n', '<leader>.', builtin.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = 'Search [/] in Open Files' })

      -- NixOS directory
      local nixos = os.getenv 'HOME' .. '/.nixos/'

      -- Shortcut for searching your dotfiles
      vim.keymap.set('n', '<leader>n', function()
        builtin.find_files { cwd = nixos }
      end, { desc = 'Search [N]ixos Config' })
    end,
  },
  {
    'debugloop/telescope-undo.nvim',
    dependencies = {
      {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    keys = {
      {
        '<leader>u',
        '<cmd>Telescope undo<cr>',
        desc = '[U]ndo History',
      },
    },
    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension 'undo'
    end,
  },
}
