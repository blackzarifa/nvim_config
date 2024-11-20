return {
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      mappings = {
        basic = true,
        extra = true,
      },
      pre_hook = function()
        if not vim.tbl_contains({ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }, vim.bo.filetype) then
          return
        end

        return require('ts_context_commentstring.internal').calculate_commentstring {
          key = 'default',
          location = require('ts_context_commentstring.utils').get_cursor_location(),
        }
      end,
    },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },
}
