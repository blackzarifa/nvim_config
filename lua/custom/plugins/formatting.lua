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
            '--trailing-comma=es5',
            '--bracket-spacing=true',
            '--bracket-same-line=false',
            '--prose-wrap=preserve',
            '$FILENAME',
          },
        },
        eslint_d = {
          command = 'eslint_d',
          args = { '--fix-to-stdout', '--stdin', '--stdin-filename', '$FILENAME' },
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
      },
      formatters_by_ft = {
        javascript = { 'eslint_d', 'prettierd' },
        typescript = { 'eslint_d', 'prettierd' },
        vue = { 'eslint_d', 'prettierd' },
        css = { 'prettierd' },
        html = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
        lua = { 'stylua' },
        python = { 'black' },
        go = { 'golines', 'goimports', 'gofmt' },
      },
      format_on_save = { timeout_ms = 2000, lsp_fallback = true },
      parallel_workers = 1,
      stop_after_first = false,
    },
  },
}
