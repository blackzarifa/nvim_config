return {
  'doki-theme/doki-theme-vim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd [[colorscheme ishtar_dark]]

    local notify = require 'notify'
    notify.setup {
      background_colour = '#000000',
      timeout = 0,
    }
  end,
}
