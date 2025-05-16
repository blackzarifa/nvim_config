local vim = vim

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- Basic setup
      require('mason').setup()

      -- Standard keymaps
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
        map('gr', require('telescope.builtin').lsp_references, 'Goto References')
        map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')
        map('<leader>d', vim.diagnostic.open_float, 'Show Diagnostics')
        map('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
        map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
        map('<leader>f', function()
          vim.lsp.buf.format { async = true }
        end, 'Format')
      end

      -- Capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lspconfig = require 'lspconfig'

      -- Direct server setup - no fancy abstractions
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
          },
        },
      }

      lspconfig.volar.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'vue' },
        init_options = {
          typescript = {
            tsdk = vim.fn.stdpath 'data' .. '/mason/packages/typescript-language-server/node_modules/typescript/lib',
          },
        },
      }

      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        cmd = { 'typescript-language-server', '--stdio' },
      }

      -- Configure diagnostics display
      local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end

      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
        },
      }
    end,
  },
}
