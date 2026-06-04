-- Code completion and LSP integration
do
  vim.pack.add {
    GH 'zbirenbaum/copilot.lua',
    GH 'j-hui/fidget.nvim',
    GH 'neovim/nvim-lspconfig',
    { src = GH 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
    { src = GH 'saghen/blink.cmp', version = vim.version.range '1.*' },
    GH 'lervag/vimtex' ,
  }

  -- AI Tools
  require('copilot').setup {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = '<S-TAB>',
        accept_word = false,
        accept_line = false,
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
    },
    filetypes = {
      markdown = false,
      tex = false,
    },
  }

  -- Main LSP Configuration
  require('fidget').setup {} -- Show LSP (and other processes) progress

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- If the LSP server supports a feature, then enable it and set up a keybind to toggle it.
      local enable_lsp_feature = function(feature, method, key, desc)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(method) then
          feature.enable(true)
          map('<leader>t' .. key, function()
            feature.enable(not feature.is_enabled { bufnr = event.buf })
          end, desc)
        end
      end

      map('<leader>r', vim.lsp.buf.rename, '[R]ename')
      map('<leader>x', vim.lsp.codelens.run, 'Codelens E[X]ecute')
      map('<leader>a', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- Enable some LSP features that are nice
      enable_lsp_feature(vim.lsp.inlay_hint, 'textDocument/inlayHint', 't', '[T]oggle Inlay Hints')
      enable_lsp_feature(vim.lsp.codelens, 'textDocument/codeLens', 'c', '[T]oggle [C]odelens')
      enable_lsp_feature(vim.lsp.linked_editing_range, 'textDocument/linkedEditingRange', 'e', '[T]oggle Linked [E]diting Range')
    end,
  })

  local servers = {
    -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
    pyright = {},
    rust_analyzer = {
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
          },
          check = {
            command = 'clippy',
          },
        },
      },
    },
    ccls = {
      capabilities = {
        offsetEncoding = 'utf-8',
      },
    },
    jdtls = {},
    asm_lsp = {
      filetypes = { 'asm', 'nasm', 's', 'vmasm' },
    },
    nixd = {},
    ts_ls = {},
    texlab = {},
    lua_ls = {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          workspace = {
            checkThirdParty = false,
            -- Tells lua_ls where to find all the Lua files that you have loaded
            -- for your neovim configuration.
            library = {
              '${3rd}/luv/library',
              unpack(vim.api.nvim_get_runtime_file('', true)),
            },
          },
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    },
  }

  -- Add LSP servers to the setup
  for server, config in pairs(servers) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
  end

  -- [[ Snippet Engine ]]

  -- [[ Autocomplete Engine ]]
  require('blink.cmp').setup {
    keymap = {
      preset = 'super-tab',
      ['<S-Tab>'] = false,
    },

    appearance = {
      nerd_font_variant = 'normal',
    },

    -- Autoview documentation
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    fuzzy = { implementation = 'prefer_rust_with_warning' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }

  -- LaTeX support
  vim.g.vimtex_view_method = 'zathura'
  vim.g.vimtex_syntax_nospell_comments = true
end
