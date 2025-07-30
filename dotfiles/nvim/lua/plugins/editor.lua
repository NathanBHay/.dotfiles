-- Changes to basic editing functionality
return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  {
    'echasnovski/mini.nvim',
    config = function()
      -- maybe mini.ai, splitojoin
      require('mini.comment').setup()
      require('mini.splitjoin').setup()
      require('mini.bracketed').setup()
      require('mini.jump').setup {
        delay = {
          highlight = 1500,
        },
      }
      require('mini.surround').setup {
        mappings = {
          add = 'gsa', -- Add surrounding in Normal and Visual modes
          delete = 'gsd', -- Delete surrounding
          replace = 'gsr', -- Replace surrounding
          find = 'gsf', -- Find right surrounding
          find_left = 'gsF', -- Find left surrounding
          highlight = 'gsh', -- Highlight surrounding
          update_n_lines = 'gsn', -- Update `n_lines` for surrounding
        },
      }

      local pattern = '[^\\][^%w]'
      require('mini.pairs').setup {
        mappings = {
          ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },
          ['('] = { neigh_pattern = pattern },
          ['['] = { neigh_pattern = pattern },
          ['{'] = { neigh_pattern = pattern },
          ['"'] = { neigh_pattern = '[^%a\\][^%w]' },
          ["'"] = { neigh_pattern = '[^%a\\][^%w]' },
          ['`'] = { neigh_pattern = '[^%a\\][^%w]' },
        },
      }

      -- Rust-specific pairing for <> and '
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'rust', 'html' },
        callback = function()
          local mpairs = require 'mini.pairs'
          mpairs.map_buf(0, 'i', '<', { action = 'open', pair = '<>', neigh_pattern = pattern })
          mpairs.map_buf(0, 'i', "'", { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\&<][^%w>]' })
        end,
      })
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        rust = { 'rustfmt' },
        nix = { 'nixfmt' },
        sh = { 'shfmt', args = { '-i', '2' } },
      },
    },
  },
}
