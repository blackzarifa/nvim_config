return {
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    config = function()
      require('which-key').add {
        { '<leader>G', group = 'Git' },
      }
      local keymap = vim.keymap.set
      keymap('n', '<leader>Gs', vim.cmd.Git, { desc = 'Git Status' })
      keymap('n', '<leader>Gc', function()
        vim.cmd 'Git commit'
      end, { desc = 'Git Commit' })
      keymap('n', '<leader>Gp', function()
        vim.cmd 'Git push'
      end, { desc = 'Git Push' })
      keymap('n', '<leader>Gl', function()
        vim.cmd 'Git pull'
      end, { desc = 'Git Pu[L]l' })
      keymap('n', '<leader>Gb', function()
        vim.cmd 'Git blame'
      end, { desc = 'Git Blame' })
    end,
  },

  {
    'airblade/vim-gitgutter',
    event = 'VeryLazy',
    config = function()
      -- Disable default mappings
      vim.g.gitgutter_map_keys = 0

      -- Match your previous signs
      vim.g.gitgutter_sign_added = '▎'
      vim.g.gitgutter_sign_modified = '▎'
      vim.g.gitgutter_sign_removed = '▁'
      vim.g.gitgutter_sign_removed_first_line = '▔'
      vim.g.gitgutter_sign_modified_removed = '▎'

      -- CRITICAL: Enable line highlighting by default
      vim.g.gitgutter_highlight_lines = 1
    end,
  },

  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = 'diff2_horizontal',
            winbar_info = true,
          },
          merge_tool = {
            layout = 'diff3_horizontal',
            disable_diagnostics = true,
          },
        },
        hooks = {
          diff_buf_read = function()
            vim.opt_local.wrap = false
            vim.opt_local.list = false
          end,
        },
      }

      local keymap = vim.keymap.set
      keymap('n', '<leader>Gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git Diff View' })
      keymap('n', '<leader>Gh', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git History' })
      keymap('n', '<leader>Gq', '<cmd>DiffviewClose<cr>', { desc = 'Git Diff Quit' })
    end,
  },

  {
    'kdheepak/lazygit.nvim',
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('n', '<leader>Gg', ':LazyGit<CR>', { desc = 'LazyGit' })
    end,
  },
}
