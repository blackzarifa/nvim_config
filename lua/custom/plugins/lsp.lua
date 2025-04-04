return {
  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local on_attach = function(client, bufnr)
        -- Keybinds for available LSP actions
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
        map('gr', require('telescope.builtin').lsp_references, 'Goto References')
        map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

        --  Useful when you're on a variable and want to see what type it is.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

        -- Opens a popup that displays documentation about the word under your cursor
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or warning for this to do anything.
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

        -- Rename the variable under your cursor
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')

        map('<leader>d', vim.diagnostic.open_float, 'Show Diagnostics')

        -- Move to the previous diagnostic in your current buffer
        map('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')

        -- Move to the next diagnostic in your current buffer
        map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')

        -- Format buffer using LSP
        map('<leader>f', function()
          vim.lsp.buf.format { async = true }
        end, 'Format')
      end

      -- Configure LSP servers
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lspconfig = require 'lspconfig'

      require('mason-lspconfig').setup {
        automatic_installation = true,
        handlers = {
          function(server)
            lspconfig[server].setup {
              capabilities = capabilities,
              on_attach = on_attach,
            }
          end,
        },
      }

      local mason_registry = require 'mason-registry'
      local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'

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
        },
      }

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
