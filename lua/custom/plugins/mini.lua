-- Configuration for all mini.nvim modules
-- See: https://github.com/echasnovski/mini.nvim

return {
  -- Collection of various small independent plugins/modules
  {
    'echasnovski/mini.nvim',
    config = function()
      -- [[ Mini AI ]]
      -- Extend and create a/i textobjects
      -- See `:help mini.ai`
      -- Note: We disable some textobjects to prevent conflicts with nvim-treesitter
      require('mini.ai').setup {
        custom_textobjects = {
          f = false, -- Disable mini.ai function textobject
          c = false, -- Disable mini.ai class textobject
        },
        n_lines = 500,
      }

      -- [[ Mini Surround ]]
      -- Adds, deletes, and replaces surroundings (brackets, quotes, etc.)
      -- See `:help mini.surround`
      --[[ require('mini.surround').setup  {
        mappings = {
          add = '<leader>sa', -- Add surrounding
          delete = '<leader>sd', -- Delete surrounding
          find = '<leader>sf', -- Find surrounding (right side)
          find_left = '<leader>sF', -- Find surrounding (left side)
          highlight = '<leader>sh', -- Highlight surrounding
          replace = '<leader>sr', -- Replace surrounding
          update_n_lines = '<leader>sn', -- Update n lines
          -- Disable suffix mappings that cause overlaps
          suffix_last = '', -- Disable last
          suffix_next = '', -- Disable next
        },
      } ]]

      -- [[ Additional Mini Modules ]]
      -- Mini.nvim comes with many other modules you can enable:
      -- - mini.animate   - Animations for common actions
      -- - mini.bufremove - Buffer removing while preserving layout
      -- - mini.comment   - Fast commenting
      -- - mini.indentscope - Show scope by indent
      -- - mini.pairs     - Auto-pairing brackets and quotes
      -- And many more! Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
