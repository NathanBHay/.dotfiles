-- Git integration
return {
  {
    'kdheepak/lazygit.nvim',
    cmd = 'LazyGit',
    keys = {
      { '<leader>l', '<cmd>LazyGit<CR>', desc = '[L]azy Git', silent = true },
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
        map('n', '<leader>hs', gs.stage_hunk, { desc = '[H]unk [S]tage' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = '[H]unk [R]eset' })
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[H]unk [S]tage' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[H]unk [R]eset' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = '[H]unk [S]tage Buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[H]unk [U]ndo Stage' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = '[H]unk [R]eset Buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = '[H]unk [P]review' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, { desc = '[H]unk [B]lame' })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[H]unk [S]tage' })
        map('n', '<leader>hd', gs.diffthis, { desc = '[H]unk [D]iff' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = '[H]unk [S]tage' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
}
