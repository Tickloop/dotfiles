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
    fd_opts = "--color=never --type f --type l"
      .. " --exclude .git"
      .. " --exclude node_modules"
      .. " --exclude .venv"
      .. " --exclude __pycache__",
  },
  grep = {
    formatter = "path.filename_first",
    rg_opts = "--column --line-number --no-heading --color=always --smart-case"
      .. " --max-columns=4096"
      .. " --glob '!**/.git/**'"
      .. " --glob '!**/node_modules/**'"
      .. " --glob '!**/.venv/**'"
      .. " --glob '!**/__pycache__/**'"
      .. " -e",
  },
})

vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
}, { confirm = false })

require("gitsigns").setup({})

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
}, { confirm = false })

require("nvim-web-devicons").setup({
  color_icons = true,
  default = true,
})

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

require("solaris").setup({
  on_colors = function(colors)
    colors.bg = "#000000"
  end,
})
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

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
}, { confirm = false })

require("nvim-treesitter").setup({})
require("nvim-treesitter").install({
  "lua",
  "python",
  "go",
  "gomod",
  "gowork",
  "javascript",
  "typescript",
  "tsx",
})

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
}, { confirm = false })
