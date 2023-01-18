return function()
      require("mini.pairs").setup({
        mappings = {
          ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^<\\&%a][^>]', register = { cr = false } },

          ["<"] = { action = 'open', pair = "<>", neigh_pattern = '[%a].', register = { cr = false } },
          [">"] = { action = 'close', pair = "<>", neigh_pattern = '[%a].', register = { cr = false } },
        }
      })
      require 'mini.surround'.setup({
          custom_surroundings = {
              ['('] = { output = { left = '( ', right = ' )' } },
              ['['] = { output = { left = '[ ', right = ' ]' } },
              ['{'] = { output = { left = '{ ', right = ' }' } },
              ['<'] = { output = { left = '< ', right = 'g>' } },
          },
          mappings = {
              add = 'ys',
              delete = 'ds',
              find = '<leader>sf',
              find_left = '<leader>sF',
              highlight = '<leader>sh',
              replace = 'cs',
              update_n_lines = '',
              suffix_last = 'N',
              suffix_next = 'n',
          },
          update_n_lines = '',
      })
      vim.keymap.del('x', 'ys')
      -- for some reason this does not work properly if it isn't text
      vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]])
      vim.keymap.set('n', 'yss', 'ys_', {remap=true})
    end
