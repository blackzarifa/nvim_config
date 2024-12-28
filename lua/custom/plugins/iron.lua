return {
  {
    'hkupty/iron.nvim',
    config = function()
      require('iron.core').setup {
        config = {
          repl_definition = {
            python = {
              command = { 'jupyter', 'console', '--kernel', 'python3' },
            },
          },
          repl_open_cmd = 'belowright split',
        },
        require('which-key').add {
          { '<leader>r', group = 'REPL' },
        },
        keymaps = {
          send_motion = '<leader>rp', -- Send selected block to REPL (visual mode)
          send_line = '<leader>rl', -- Send current line to REPL
          send_file = '<leader>rf', -- Send the entire file to REPL
          exit = '<leader>rq', -- Exit the REPL
          interrupt = '<leader>ri', -- Interrupt current REPL execution
          clear = '<leader>rc', -- Clear REPL output
        },
      }
    end,
  },
}
