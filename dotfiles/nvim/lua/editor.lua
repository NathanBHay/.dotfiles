-- Changes to basic editing functionality
do
  -- Detect tabstop and shiftwidth automatically
  vim.pack.add { GH 'tpope/vim-sleuth' }

  vim.pack.add { GH 'echasnovski/mini.nvim' }
  -- require('mini.ai').setup() TODO: Enable
  require('mini.comment').setup()
  require('mini.diff').setup {
    view = {
      style = 'sign',
      signs = {
        add = '┃',
        change = '┃',
        delete = '_',
      },
    },
  }
  require('mini.splitjoin').setup()
  require('mini.bracketed').setup()
  require('mini.trailspace').setup()
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

  -- -- Rust-specific pairing for <> and '
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'rust', 'html' },
    callback = function()
      MiniPairs.map_buf(0, 'i', '<', { action = 'open', pair = '<>', neigh_pattern = pattern })
      MiniPairs.map_buf(0, 'i', "'", { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\&<][^%w>]' })
    end,
  })

  -- Autoformat
  vim.pack.add { GH 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      rust = { 'rustfmt' },
      nix = { 'nixfmt' },
      sh = { 'shfmt', args = { '-i', '2' } },
      tex = { 'tex-fmt' },
      json = { 'jq' },
    },
  }
end
