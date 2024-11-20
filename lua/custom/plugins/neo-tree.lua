return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      window = {
        position = 'right',
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<space>'] = 'none', -- Explicitly disable space
          ['a'] = {
            command = 'add',
            config = { show_path = 'relative' },
          },
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['c'] = 'copy',
          ['m'] = 'move',
          ['<cr>'] = 'open',
          ['l'] = 'open',
          ['<esc>'] = 'revert_preview',
          ['h'] = 'close_node',
          ['z'] = 'close_all_nodes',
          ['R'] = 'refresh',
          ['/'] = 'fuzzy_finder',
          ['#'] = 'fuzzy_sorter',
          ['f'] = 'filter_on_submit',
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = false,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function()
            require('neo-tree.command').execute { action = 'close' }
          end,
        },
      },
    }
  end,
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Toggle Explorer' },
  },
}
