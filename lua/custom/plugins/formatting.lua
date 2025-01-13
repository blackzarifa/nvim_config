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
          prepend_args = { '--config-precedence', 'prefer-file' },
          args = {
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
            '--stdin-filepath',
            '$FILENAME',
          },
        },
        black = {
          args = { '--fast', '-' },
        },
      },
      formatters_by_ft = {
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        vue = { 'prettierd' },
        css = { 'prettierd' },
        html = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
        lua = { 'stylua' },
        python = { 'black' },
      },
      format_on_save = { timeout_ms = 2000, lsp_fallback = true },
      parallel_workers = 1,
      stop_after_first = true,
    },
  },
}
