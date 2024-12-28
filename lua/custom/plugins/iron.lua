return {
  {
    'hkupty/iron.nvim',
    config = function()
      require('iron.core').setup {
        config = {
          repl_definition = {
            python = { command = { 'ipython' } },
          },
          repl_open_cmd = 'botright 40split', -- Open REPL at the bottom
        },
        keymaps = {
          send_motion = '<space>sc',
          visual_send = '<space>sc',
        },
      }
    end,
  },
}
