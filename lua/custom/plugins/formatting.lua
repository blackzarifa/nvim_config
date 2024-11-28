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
          -- Prettierd configuration
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
        prettier = {
          command = function()
            local prettier_path = vim.fn.getcwd() .. '/node_modules/.bin/prettier'
            if vim.fn.executable(prettier_path) == 1 then
              -- Wrap the path in quotes if it contains spaces
              return vim.fn.has 'win32' == 1 and ('"' .. prettier_path .. '.cmd"') or prettier_path
            end
            return 'prettier'
          end,
          -- Default Prettier configuration
          args = {
            '--print-width',
            '100',
            '--tab-width',
            '2',
            '--use-tabs',
            'false',
            '--semi',
            'true',
            '--single-quote',
            'true',
            '--trailing-comma',
            'es5',
            '--bracket-spacing',
            'true',
            '--bracket-same-line',
            'false',
            '--prose-wrap',
            'preserve',
            '--stdin-filepath',
            '$FILENAME',
          },
        },
      },
      formatters_by_ft = {
        javascript = { 'prettierd', 'prettier' },
        typescript = { 'prettierd', 'prettier' },
        vue = { 'prettierd', 'prettier' },
        css = { 'prettierd', 'prettier' },
        html = { 'prettierd', 'prettier' },
        json = { 'prettierd', 'prettier' },
        yaml = { 'prettierd', 'prettier' },
        markdown = { 'prettierd', 'prettier' },
        lua = { 'stylua' },
      },
      -- Add this to configure formatter fallback behavior
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      -- Add this to control if formatters should run in parallel
      parallel_workers = 1,
      -- Add this to stop after the first successful formatter
      stop_after_first = true,
    },
  },
}
