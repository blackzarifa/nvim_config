return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = 'Format buffer',
      },
      {
        '<leader>Fe',
        function()
          -- Run eslint_d manually when needed, not on every save
          require('conform').format { async = true, formatters = { 'eslint_d' } }
        end,
        mode = 'n',
        desc = 'Format with eslint_d',
      },
    },
    opts = {
      formatters = {
        prettierd = {
          args = {
            '--config-precedence=prefer-file',
            '--arrow-parens=avoid',
            '--print-width=100',
            '--tab-width=2',
            '--use-tabs=false',
            '--semi=true',
            '--single-quote=true',
            '--trailing-comma=all',
            '--bracket-spacing=true',
            '--bracket-same-line=false',
            '--prose-wrap=preserve',
            '$FILENAME',
          },
        },
        eslint_d = {
          args = {
            '--fix-to-stdout',
            '--stdin',
            '--stdin-filename',
            '$FILENAME',
          },
          stdin = true,
        },
        black = {
          args = {
            '--fast',
            '--skip-string-normalization',
            '-',
          },
        },
        gofmt = {
          args = { '-s' },
        },
        goimports = {},
        golines = {
          args = {
            '--max-len=80',
            '--base-formatter=gofmt',
          },
        },
        pint = {
          meta = {
            url = 'https://laravel.com/docs/pint',
            description = 'Laravel Pint - Laravel code style fixer',
          },
        },
        ['php-cs-fixer'] = {
          args = {
            'fix',
            '--no-interaction',
            '--quiet',
            '--using-cache=no',
            '$FILENAME',
          },
          stdin = false,
          tmpfile_format = '.php-cs-fixer.php',
        },
        ['blade-formatter'] = {
          args = {
            '--write',
            '$FILENAME',
          },
          stdin = false,
        },
      },
      formatters_by_ft = {
        -- Remove eslint_d completely from auto-formatting
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        vue = { 'prettierd' },
        css = { 'prettierd' },
        html = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
        lua = { 'stylua' },
        python = { 'black' },
        go = { 'golines', 'goimports', 'gofmt' },
        php = { 'pint', 'php-cs-fixer' },
        blade = { 'blade-formatter' },
      },
      format_on_save = function(bufnr)
        -- Only format certain files on save
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        -- Skip formatting on node_modules files
        if bufname:match 'node_modules' then
          return
        end

        -- Skip eslint_d automatic running completely
        return {
          timeout_ms = 1000,
          lsp_fallback = true,
        }
      end,
    },
    config = function(_, opts)
      -- Only keep this to support manual eslint_d formatting, don't start on load
      vim.api.nvim_create_user_command('EslintFix', function()
        require('conform').format { formatters = { 'eslint_d' } }
      end, { desc = 'Fix current file with eslint_d' })

      require('conform').setup(opts)
    end,
  },
}
