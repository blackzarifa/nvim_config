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
        python = { 'black' },
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
