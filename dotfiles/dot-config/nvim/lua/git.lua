vim.pack.add {
  GH 'lewis6991/gitsigns.nvim',
}

-- Open lazygit in a floating window
vim.keymap.set('n', '<leader>l', Snacks.lazygit.open, { desc = '[L]azyGit', silent = true })

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation that respects diff mode and shows a preview of the hunk
    local function nav(direction)
      return function()
        if vim.wo.diff then
          vim.cmd.normal { direction == 'next' and ']c' or '[c', bang = true }
        else
          gitsigns.nav_hunk(direction, { preview = false }, function()
            gitsigns.preview_hunk_inline()
            vim.cmd 'normal! zz'
          end)
        end
      end
    end

    map('n', ']c', nav 'next', { desc = 'Jump to next git [c]hange' }) -- Probably remove one of these two
    map('n', '[c', nav 'prev', { desc = 'Jump to previous git [c]hange' })
    map('n', ']h', nav 'next', { desc = 'Jump to next git [h]unk' })
    map('n', '[h', nav 'prev', { desc = 'Jump to previous git [h]unk' })

    -- Actions
    -- visual mode
    map('v', 'gh', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = '[g]it stage selected lines' })
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [r]eset hunk' })
    -- normal mode
    map('n', 'gh', gitsigns.stage_hunk, { desc = '[g]it [s]tage hunk' })
    map('n', 'gH', gitsigns.reset_hunk, { desc = '[g]it [r]eset hunk' })
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline' })
    map('n', '<leader>hb', function()
      gitsigns.blame_line { full = true }
    end, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '@'
    end, { desc = 'git [D]iff against last commit' })
    map('n', '<leader>hQ', function()
      gitsigns.setqflist 'all'
    end, { desc = 'git hunk [Q]uickfix list (all files in repo)' })
    map('n', '<leader>hq', gitsigns.setqflist, { desc = 'git hunk [q]uickfix list (all changes in this file)' }) -- TODO: Remove if unused
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git intra-line [w]ord diff' })
    map('n', '<leader>th', gitsigns.toggle_linehl, { desc = '[T]oggle git [h]unk diffs' })

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
  end,
}
