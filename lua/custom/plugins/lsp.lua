return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil

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

      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lspconfig = require 'lspconfig'

      require('mason').setup()

      local servers = {
        gopls = {},
        ts_ls = {
          init_options = {
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
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
          },
        },
        volar = {},
        tailwindcss = {
          filetypes = {
            'css',
            'postcss',
            'sass',
            'scss',
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'vue',
            'svelte',
          },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                vue = 'html',
              },
              experimental = {
                classRegex = {
                  { 'class=["\'`]([^"\'`]*)["\'`]', 1 },
                  { ':class=["\'`]([^"\'`]*)["\'`]', 1 },
                  { 'classList\\.\\w+\\(["\'`]([^"\'`]*)["\'`]\\)', 1 },
                },
              },
            },
          },
        },
        svelte = {
          settings = {
            svelte = {
              plugin = {
                html = { completions = { enable = true, emmet = false } },
                svelte = { completions = { enable = true } },
                css = { completions = { enable = true, emmet = true } },
                typescript = {
                  enable = true,
                  diagnostics = { enable = true },
                  hover = { enable = true },
                  completions = { enable = true },
                },
              },
            },
          },
        },
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 5000000,
                associations = { '*.php', '*.phtml' },
                exclude = {
                  '**/.git/**',
                  '**/.svn/**',
                  '**/.hg/**',
                  '**/CVS/**',
                  '**/.DS_Store/**',
                  '**/node_modules/**',
                  '**/bower_components/**',
                  '**/vendor/**/{Tests,tests}/**',
                  '**/.history/**',
                  '**/vendor/**/vendor/**',
                },
              },

              telemetry = {
                enabled = false,
              },
              environment = {
                includePaths = {
                  'vendor',
                },
              },
            },
          },
        },

      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end

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
