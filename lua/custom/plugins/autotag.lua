return {
  'windwp/nvim-ts-autotag',
  event = 'InsertEnter',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('nvim-ts-autotag').setup {
      filetypes = { 'html', 'xml', 'svelte', 'vue' },
      enable_rename = true,
      skip_tags = {
        'area',
        'base',
        'br',
        'col',
        'command',
        'embed',
        'hr',
        'img',
        'slot',
        'input',
        'keygen',
        'link',
        'meta',
        'param',
        'source',
        'track',
        'wbr',
        'menuitem',
      },
    }
  end,
}
