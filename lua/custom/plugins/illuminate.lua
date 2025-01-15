return {
  'RRethy/vim-illuminate',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('illuminate').configure {
      delay = 200,
      -- Providers: lsp for the fancy stuff, treesitter for the weird stuff, regex for the desperate stuff
      providers = {
        'lsp',
        'treesitter',
        'regex',
      },
      -- Don't illuminate in these file types
      filetypes_denylist = {
        'dirvish',
        'fugitive',
        'alpha',
        'NvimTree',
        'lazy',
        'netrw',
        'TelescopePrompt',
      },
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
      -- Default keymaps
      -- <a-n> next reference
      -- <a-p> previous reference
      -- <a-i> illuminate word under cursor
    }
  end,
}
