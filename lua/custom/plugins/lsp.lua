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
      -- Brief Aside: **What is LSP?**
      -- LSP is an acronym you'll see everywhere in Neovim plugins and config.
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and IDEs communicate with servers that provide language intelligence like:
      -- - Go to definition
      -- - Find references
      -- - Autocompletion
      -- - Symbol search
      -- - Diagnostics

      -- These features historically had to be implemented separately for every editor
      -- and every language, which was a ton of work. LSP creates a standardized way
      -- for this communication to happen, so editor plugins can be written once and
      -- language services can be written once and work with many editors.

      local on_attach = function(client, bufnr)
        -- Keybinds for available LSP actions
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined.
        map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, 'Goto References')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

        -- Jump to the type definition of the word under your cursor.
        --  Useful when you're on a variable and want to see what type it is.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

        -- Opens a popup that displays documentation about the word under your cursor
        --  Useful when you want to see what a function does without jumping to its definition.
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or warning for this to do anything.
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

        -- Rename the variable under your cursor
        --  Useful for refactoring code.
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')

        -- Show diagnostics in a floating window
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

      require('mason-lspconfig').setup {
        automatic_installation = true,
        handlers = {
          function(server)
            require('lspconfig')[server].setup {
              capabilities = capabilities,
              on_attach = on_attach,
            }
          end,
        },
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
