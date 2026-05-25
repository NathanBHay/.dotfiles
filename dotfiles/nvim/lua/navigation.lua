-- Functions that enable navigation between files and buffers
do
  -- Fuzzy Finder (files, lsp, etc)
  local telescope_plugins = {
    GH 'nvim-tree/nvim-web-devicons',
    GH 'nvim-telescope/telescope.nvim',
    GH 'nvim-telescope/telescope-ui-select.nvim',
    GH 'debugloop/telescope-undo.nvim',
  }
  if vim.fn.executable 'make' == 1 then
    table.insert(telescope_plugins, GH 'nvim-telescope/telescope-fzf-native.nvim')
  end

  vim.pack.add(telescope_plugins)
  require('telescope').setup {
    -- You can put your default mappings / updates / etc. in here
    --  All the info you're looking for is in `:help telescope.setup()`
    --
    defaults = {
      mappings = {
        i = { ['<c-enter>'] = 'to_fuzzy_refine', ['<esc>'] = 'close' },
      },
    },
    -- pickers = {}
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }

  -- Enable telescope extensions, if they are installed
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
  pcall(require('telescope').load_extension, 'undo')

  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>q', builtin.quickfix, { desc = 'Search [Q]uick Fix' })
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
  vim.keymap.set('n', '<leader>u', '<cmd>Telescope undo<cr>', { desc = '[U]ndo History' })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gi', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
      vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
    end,
  })

  -- Also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = 'Search [/] in Open Files' })

  -- Shortcut for searching your dotfiles
  local nixos = os.getenv 'HOME' .. '/.nixos/'
  vim.keymap.set('n', '<leader>n', function()
    builtin.find_files { cwd = nixos }
  end, { desc = 'Search [N]ixos Config' })
end
