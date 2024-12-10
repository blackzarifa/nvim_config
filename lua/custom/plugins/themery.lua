return {
  'zaldih/themery.nvim',
  lazy = false,
  config = function()
    -- Get all available colorschemes
    local available_themes = vim.fn.getcompletion('', 'color')
    local default_themes = {
      'blue',
      'darkblue',
      'default',
      'delek',
      'desert',
      'elflord',
      'evening',
      'industry',
      'koehler',
      'lunaperche',
      'morning',
      'murphy',
      'pablo',
      'peachpuff',
      'quiet',
      'randomhue',
      'retrobox',
      'ron',
      'shine',
      'slate',
      'sorbet',
      'torte',
      'wildcharm',
      'zaibatsu',
      'zellner',
    }
    -- Filter out default themes
    local custom_themes = {}
    for _, theme in ipairs(available_themes) do
      local is_default = false
      for _, default in ipairs(default_themes) do
        if theme == default then
          is_default = true
          break
        end
      end
      if not is_default then
        table.insert(custom_themes, theme)
      end
    end

    require('themery').setup {
      themes = custom_themes,
      livePreview = true,
    }
    vim.keymap.set('n', '<leader>T', '<cmd>Themery<cr>', { desc = 'Themery' })
  end,
}
