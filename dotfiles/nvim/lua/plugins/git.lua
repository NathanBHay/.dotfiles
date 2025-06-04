-- Git integration
return {
  {
    'kdheepak/lazygit.nvim',
    cmd = 'LazyGit',
    keys = {
      { '<leader>lg', '<cmd>LazyGit<CR>', desc = '[L]azy [G]it', silent = true },
    },
    dependencies = 'nvim-lua/plenary.nvim',
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- Visual mode
        map('v', '<leader>ls', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[L]azygit Hunk [S]tage' })
        map('v', '<leader>lr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[L]azygit Hunk [R]eset' })

        -- Normal mode
        map('n', '<leader>ls', gitsigns.stage_hunk, { desc = '[L]azygit Hunk [S]tage' })
        map('n', '<leader>lr', gitsigns.reset_hunk, { desc = '[L]azygit Hunk [R]eset' })
        map('n', '<leader>lS', gitsigns.stage_buffer, { desc = '[L]azygit Hunk [S]tage Buffer' })
        map('n', '<leader>lu', gitsigns.undo_stage_hunk, { desc = '[L]azygit Hunk [U]ndo Stage' })
        map('n', '<leader>lR', gitsigns.reset_buffer, { desc = '[L]azygit Hunk [R]eset Buffer' })
        map('n', '<leader>lp', gitsigns.preview_hunk, { desc = '[L]azygit Hunk [P]review' })
        map('n', '<leader>lb', function()
          gitsigns.blame_line { full = true }
        end, { desc = '[L]azygit Hunk [B]lame' })
        map('n', '<leader>ltb', gitsigns.toggle_current_line_blame, { desc = '[L]azygit Hunk [S]tage' })
        map('n', '<leader>ld', gitsigns.diffthis, { desc = '[L]azygit Hunk [D]iff' })
        map('n', '<leader>ltd', gitsigns.toggle_deleted, { desc = '[L]azygit Hunk [S]tage' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
}
