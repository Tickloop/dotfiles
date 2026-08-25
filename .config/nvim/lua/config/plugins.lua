-- Third-party plugins go here, one at a time.
-- Neovim 0.12 provides vim.pack, so no separate plugin manager is needed.

vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
}, { confirm = false })

require("fzf-lua").setup({
  "default-title",
  winopts = {
    height = 0.85,
    width = 0.90,
    row = 0.5,
    col = 0.5,
    border = "rounded",
    preview = {
      default = "builtin",
      hidden = false,
      layout = "horizontal",
      horizontal = "right:55%",
    },
  },
  files = {
    hidden = true,
    formatter = "path.filename_first",
  },
  grep = {
    formatter = "path.filename_first",
  },
})

vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
}, { confirm = false })

require("gitsigns").setup({})

vim.pack.add({
  "https://github.com/folke/snacks.nvim",
}, { confirm = false })

require("snacks").setup({
  explorer = {
    enabled = true,
    replace_netrw = false,
  },
  picker = {
    enabled = true,
    ui_select = false,
  },
})

vim.pack.add({
  "https://github.com/Tickloop/solaris.nvim",
}, { confirm = false })

require("solaris").setup({})
vim.cmd.colorscheme("solaris")

vim.pack.add({
  "https://github.com/lukas-reineke/indent-blankline.nvim",
}, { confirm = false })

require("ibl").setup({
  indent = {
    char = "│",
    tab_char = "│",
  },
  scope = {
    enabled = true,
    char = "│",
    show_start = false,
    show_end = false,
  },
})
