return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = { { '<leader>M', '<cmd>Mason<cr>', desc = 'Mason' } },
    build = ':MasonUpdate',
    opts = {
      ensure_installed = {
        'stylua',
        'eslint_d',
        'prettierd',
        'typescript-language-server',
        'json-lsp',
        'gopls',
        'tailwindcss-language-server',
        'intelephense',
        'php-cs-fixer',
        'pint',
        'blade-formatter',
      },
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require 'mason-registry'
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
}
