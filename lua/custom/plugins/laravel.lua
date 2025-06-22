return {
  {
    'adalessa/laravel.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'tpope/vim-dotenv',
      'MunifTanjim/nui.nvim',
      'nvimtools/none-ls.nvim',
      'kevinhwang91/promise-async',
    },
    cmd = { 'Laravel' },
    keys = {
      { '<leader>la', ':Laravel artisan<cr>', desc = 'Laravel Artisan' },
      { '<leader>lr', ':Laravel routes<cr>', desc = 'Laravel Routes' },
      { '<leader>lm', ':Laravel related<cr>', desc = 'Laravel Related' },
    },
    event = { 'VeryLazy' },
    config = function()
      require('laravel').setup {
        lsp_server = 'intelephense',
        features = {
          null_ls = {
            enable = true,
          },
          route_info = {
            enable = true,
          },
        },
      }
    end,
  },
  {
    'tpope/vim-dotenv',
    event = 'VeryLazy',
  },
}
