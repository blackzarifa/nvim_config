return {
  'hkupty/iron.nvim',
  config = function()
    local iron = require 'iron.core'

    iron.setup {
      config = {
        repl_definition = {
          python = {
            command = { 'jupyter', 'console', '--kernel', 'python3' },
          },
        },
        repl_open_cmd = 'belowright split',
      },
    }

    require('which-key').add {
      { '<leader>r', group = 'REPL' },
    }

    local map = vim.keymap.set
    map('n', '<leader>rs', iron.repl_for, { desc = 'Open REPL' })
    map('n', '<leader>rr', iron.send, { desc = 'Send to REPL' })
    map('n', '<leader>rq', iron.close_repl, { desc = 'Close REPL' })
    map('n', '<leader>rl', iron.send_line, { desc = 'Send Line' })
    map('n', '<leader>rf', iron.send_file, { desc = 'Send File' })
    map('n', '<leader>rc', iron.send_until_cursor, { desc = 'Send Until Cursor' })
    map('n', '<leader>rm', iron.mark_motion, { desc = 'Mark Motion' })
    map('v', '<leader>rm', iron.mark_visual, { desc = 'Mark Visual' })
  end,
}
