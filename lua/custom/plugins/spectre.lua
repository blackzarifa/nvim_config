return {
  'nvim-pack/nvim-spectre',
  keys = {
    {
      '<leader>S',
      function()
        require('spectre').toggle()
      end,
      desc = 'Toggle Spectre Search/Replace',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('spectre').setup {

      color_devicons = true,
      line_sep_start = '┌-----------------------------------------',
      result_padding = '¦  ',
      line_sep = '└-----------------------------------------',
      highlight = {
        ui = 'String',
        search = 'DiffChange',
        replace = 'DiffDelete',
      },
      mapping = {
        ['tab'] = {
          map = '<Tab>',
          cmd = "<cmd>lua require('spectre').tab()<cr>",
          desc = 'next query',
        },
        ['shift-tab'] = {
          map = '<S-Tab>',
          cmd = "<cmd>lua require('spectre').tab_shift()<cr>",
          desc = 'previous query',
        },
        ['change_replace_sed'] = {
          map = 'trs',
          cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
          desc = 'use sed to replace',
        },
        ['change_replace_oxi'] = {
          map = 'tro',
          cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
          desc = 'use oxi to replace',
        },
        ['run_replace'] = {
          map = '<leader>R',
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = 'replace all',
        },
        ['toggle_live_update'] = {
          map = 'tu',
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = 'update when vim writes to file',
        },
        ['toggle_ignore_case'] = {
          map = 'ti',
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = 'toggle ignore case',
        },
        ['toggle_ignore_hidden'] = {
          map = 'th',
          cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          desc = 'toggle search hidden',
        },
      },
      find_engine = {
        ['rg'] = {
          cmd = 'rg',
          args = {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
          },
          options = {
            ['ignore-case'] = {
              value = '--ignore-case',
              icon = '[I]',
              desc = 'ignore case',
            },
            ['hidden'] = {
              value = '--hidden',
              desc = 'hidden file',
              icon = '[H]',
            },
          },
        },
        ['ag'] = {
          cmd = 'ag',
          args = {
            '--vimgrep',
            '-s',
          },
          options = {
            ['ignore-case'] = {
              value = '-i',
              icon = '[I]',
              desc = 'ignore case',
            },
            ['hidden'] = {
              value = '--hidden',
              desc = 'hidden file',
              icon = '[H]',
            },
          },
        },
      },

      replace_engine = {
        ['sed'] = {
          cmd = 'sed',
          args = nil,
          options = {
            ['ignore-case'] = {
              value = '--ignore-case',
              icon = '[I]',
              desc = 'ignore case',
            },
          },
        },
        ['oxi'] = {
          cmd = 'oxi',
          args = {},
          options = {
            ['ignore-case'] = {
              value = 'i',
              icon = '[I]',
              desc = 'ignore case',
            },
          },
        },
        ['sd'] = {
          cmd = 'sd',
          options = {},
        },
      },
      default = {
        find = {
          cmd = 'rg',
          options = { 'ignore-case' },
        },
        replace = {
          cmd = 'sed',
        },
      },
    }
  end,
}
