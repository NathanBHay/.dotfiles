-- Theming for the editor
return {
  {
    'catppuccin/nvim',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme here
      vim.cmd.colorscheme 'catppuccin'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-lualine/lualine.nvim' },
    opts = {
      theme = 'catppuccin',
    },
  },

  -- Highlight todo, notes, perf, hack, fix, warning
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local dashboard = require 'alpha.themes.dashboard'
      dashboard.section.header.val = {
        [[=================     ===============     ===============   ========  ========]],
        [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
        [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
        [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
        [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
        [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
        [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
        [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
        [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
        [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
        [[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
        [[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
        [[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
        [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
        [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
        [[||.=='    _-'                                                     `' |  /==.||]],
        [[=='    _-'                        N E O V I M                         \/   `==]],
        [[\   _-'                                                                `-_   /]],
        [[ `''                                                                      ``' ]],
      }
      dashboard.section.buttons.val = {
        dashboard.button('e', '  New file', ':enew<CR>'),
        dashboard.button('f', '  Find file', ':Telescope find_files<CR>'),
        dashboard.button('r', '  Recently opened files', ':Telescope oldfiles<CR>'),
        dashboard.button('k', '  Keymaps', ':Telescope keymaps<CR>'),
        dashboard.button('p', '󰂖  Plugins', ':Lazy<CR>'),
        dashboard.button('c', '  Config', ':Telescope find_files cwd=~/.nixos <CR>'),
        dashboard.button('q', '  Quit', ':qa<CR>'),
      }
      require('alpha').setup(dashboard.config)
      vim.api.nvim_create_autocmd('User', {
        callback = function()
          local stats = require('lazy').stats()
          local ms = math.floor(stats.startuptime * 100) / 100
          dashboard.section.footer.val = '\nLoaded ' ..
          stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
