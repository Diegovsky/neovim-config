return {
  ensure_installed = { "c", "lua", "vim", "query", "markdown", "markdown_inline", "cpp", "rust", "python", "json" },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true,
    -- disable = { "python", "rust" },
  },
  yati = { enable = true },
  autopairs = { enable = true },
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {},
    },
  }
}
