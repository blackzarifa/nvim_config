return {
  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local on_attach = function(client, bufnr)
        -- Universal fix: Disable semantic tokens to prevent highlighting conflicts
        -- This works for ALL frameworks (Vue, React, Svelte, etc.)
        client.server_capabilities.semanticTokensProvider = nil

        -- Keybinds for available LSP actions
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

      -- Configure LSP servers
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lspconfig = require 'lspconfig'

      -- Just set up Mason without any automatic features
      require('mason').setup()

      -- Set up your typescript server with expanded framework support
      local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
      lspconfig['ts_ls'].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              location = vue_language_server_path,
              languages = { 'javascript', 'typescript', 'vue' },
            },
          },
        },
        filetypes = {
          'javascript',
          'typescript',
          'vue',
          'javascript.jsx',
          'javascriptreact',
          'typescript.tsx',
          'typescriptreact',
          'svelte',
        },
      }

      -- Set up Volar for Vue files
      lspconfig['volar'].setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Change diagnostic symbols in the sign column
      local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end

      -- Configure diagnostics display
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
