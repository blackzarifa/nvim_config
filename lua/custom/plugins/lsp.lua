return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },

  { 'williamboman/mason.nvim', config = true },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        -- TypeScript config with inlay hints
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
          },
        },
        volar = {
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
        },
        svelte = {},
        tailwindcss = {},
        cssls = {},
        html = {},
        jsonls = {},
        emmet_ls = {},
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        handlers = {
          function(server_name)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local server = servers[server_name] or {}
            -- Merge default capabilities with server-specific settings
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- Plugin for showing LSP progress
  { 'j-hui/fidget.nvim', opts = {} },

  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { Error = '', Warn = '', Hint = '', Info = '' }
        for type, icon in pairs(signs) do
          local hl = 'DiagnosticSign' .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
      end

      -- Setup keybindings when an LSP attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, modes)
            modes = modes or 'n'
            -- Handle both string and table modes
            if type(modes) == 'string' then
              vim.keymap.set(modes, keys, func, { buffer = event.buf, desc = desc })
            else
              -- Handle multiple modes
              for _, mode in ipairs(modes) do
                vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
              end
            end
          end

          local wk = require 'which-key'
          wk.add {
            -- Groups
            { '<leader>c', group = 'Code' },
            { '<leader>d', group = 'Document' },
            { '<leader>w', group = 'Workspace' },
            { '<leader>r', group = 'Rename' },

            -- Leader mappings
            { '<leader>ca', desc = 'Code Action' },
            { '<leader>ds', desc = 'Document Symbols' },
            { '<leader>ws', desc = 'Workspace Symbols' },
            { '<leader>rn', desc = 'Rename Symbol' },
            { '<leader>D', desc = 'Type Definition' },

            -- Goto mappings
            { 'gd', desc = 'Definition' },
            { 'gr', desc = 'References' },
            { 'gI', desc = 'Implementation' },
            { 'gD', desc = 'Declaration' },
          }

          map('gd', require('telescope.builtin').lsp_definitions, 'Goto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, 'Goto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, 'Goto [I]mplementation')
          --[[ map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition') ]]
          --[[ map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document [S]ymbols') ]]
          --[[ map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols') ]]
          map('<leader>rn', vim.lsp.buf.rename, 'Re[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'v' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Document highlight configuration
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

            -- Highlight references when cursor holds
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })

            -- Clear highlights when cursor moves
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })

            -- Cleanup on LSP detach
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(detach_event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = detach_event.buf }
              end,
            })
          end

          -- Toggle inlay hints if supported
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>ch', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay [H]ints')
          end
        end,
      })
    end,
  },

  -- Add Mason tools installer to manage formatters
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
          'prettier',
          'eslint_d',
          'stylua',
        },
      }
    end,
  },

  -- Formatting configuration
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters = {
        prettier = {
          prepend_args = {
            '--tab-width',
            '2',
            '--print-width',
            '100',
            '--single-quote',
            '--trailing-comma',
            'es5',
          },
        },
        stylua = {
          prepend_args = {
            '--indent-type',
            'Spaces',
            '--indent-width',
            '2',
          },
        },
      },
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 2500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier', 'eslint_d', stop_after_first = true },
        typescript = { 'prettier', 'eslint_d', stop_after_first = true },
        javascriptreact = { 'prettier', 'eslint_d', stop_after_first = true },
        typescriptreact = { 'prettier', 'eslint_d', stop_after_first = true },
        svelte = { 'prettier', 'eslint_d', stop_after_first = true },
        vue = { 'prettier', 'eslint_d', stop_after_first = true },
        json = { 'prettier' },
        html = { 'prettier' },
        markdown = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        -- You can use 'stop_after_first' to run the first available formatter
        -- python = { "isort", "black", stop_after_first = true },
      },
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-u>'] = cmp.mapping.scroll_docs(4),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Advanced snippet navigation
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
}
