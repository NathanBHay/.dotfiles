-- Functions that enable navigation between files and buffers
do
  vim.keymap.set('n', '<leader>q', Snacks.picker.qflist, { desc = 'Search [Q]uick Fix' })
  -- vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Search [H]elp' })
  vim.keymap.set('n', '<leader>k', Snacks.picker.keymaps, { desc = 'Search [K]eymaps' })
  vim.keymap.set('n', '<leader>f', Snacks.picker.smart, { desc = 'Search [F]iles' })
  vim.keymap.set('n', '<leader>s', Snacks.picker.pickers, { desc = 'Search [S]elect Telescope' })
  vim.keymap.set('n', '<leader>w', Snacks.picker.grep_word, { desc = 'Search current [W]ord' })
  vim.keymap.set('n', '<leader>g', Snacks.picker.grep, { desc = 'Search by [G]rep' })
  vim.keymap.set('n', '<leader>d', Snacks.picker.diagnostics, { desc = 'Search [D]iagnostics' })
  vim.keymap.set('n', '<leader>F', Snacks.picker.buffers, { desc = 'Search Buffers' })
  vim.keymap.set('n', '<leader>.', Snacks.picker.recent, { desc = 'Search Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader><leader>', Snacks.picker.resume, { desc = '[ ] Search Last' })
  vim.keymap.set('n', '<leader>u', Snacks.picker.undo, { desc = '[U]ndo History' })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      vim.keymap.set('n', 'gr', Snacks.picker.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gi', Snacks.picker.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', 'gd', Snacks.picker.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gt', Snacks.picker.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
      vim.keymap.set('n', 'gO', Snacks.picker.lsp_symbols, { buffer = buf, desc = 'Open Document Symbols' })
      vim.keymap.set('n', 'gW', Snacks.picker.lsp_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
    end,
  })

  -- Also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>/', function()
    Snacks.picker.grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = 'Search [/] in Open Files' })

  -- Shortcut for searching your dotfiles
  local dotfiles = os.getenv 'HOME' .. '/.dotfiles/'
  vim.keymap.set('n', '<leader>n', function()
    Snacks.picker.files { cwd = dotfiles }
  end, { desc = 'Search Dotfile Config' })
end
