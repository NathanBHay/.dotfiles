-- Git integration
return {
  {
    'kdheepak/lazygit.nvim',
    cmd = 'LazyGit',
    keys = {
      { '<leader>ll', '<cmd>LazyGit<CR>', desc = '[L]azy Git', silent = true },
    },
    dependencies = 'nvim-lua/plenary.nvim',
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Actions
        map('n', '<leader>ls', gs.stage_hunk, { desc = '[L]azygit Hunk [S]tage' })
        map('n', '<leader>lr', gs.reset_hunk, { desc = '[L]azygit Hunk [R]eset' })
        map('v', '<leader>ls', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[L]azygit Hunk [S]tage' })
        map('v', '<leader>lr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[L]azygit Hunk [R]eset' })
        map('n', '<leader>lS', gs.stage_buffer, { desc = '[L]azygit Hunk [S]tage Buffer' })
        map('n', '<leader>lu', gs.undo_stage_hunk, { desc = '[L]azygit Hunk [U]ndo Stage' })
        map('n', '<leader>lR', gs.reset_buffer, { desc = '[L]azygit Hunk [R]eset Buffer' })
        map('n', '<leader>lp', gs.preview_hunk, { desc = '[L]azygit Hunk [P]review' })
        map('n', '<leader>lb', function()
          gs.blame_line { full = true }
        end, { desc = '[L]azygit Hunk [B]lame' })
        map('n', '<leader>ltb', gs.toggle_current_line_blame, { desc = '[L]azygit Hunk [S]tage' })
        map('n', '<leader>ld', gs.diffthis, { desc = '[L]azygit Hunk [D]iff' })
        map('n', '<leader>ltd', gs.toggle_deleted, { desc = '[L]azygit Hunk [S]tage' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
}
