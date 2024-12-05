-- Changes to basic editing functionality
return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'm4xshen/autoclose.nvim',
    event = 'InsertEnter',
    opts = {
      options = {
        disable_when_touch = true,
      },
    },
  },

  { -- Surround
    'kylechui/nvim-surround',
    event = 'InsertEnter',
    opts = {},
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        java = { 'google-java-format' },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        javascript = { { "prettierd", "prettier" } },
      },
    },
  },
}
