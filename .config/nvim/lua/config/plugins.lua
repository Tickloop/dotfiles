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

require("gitsigns").setup({
  preview_config = {
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
})

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
}, { confirm = false })

require("nvim-web-devicons").setup({
  color_icons = true,
  default = true,
})

vim.pack.add({
  "https://github.com/nvim-mini/mini.pairs",
}, { confirm = false })

require("mini.pairs").setup()

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
  on_highlights = function(highlights)
    highlights.CursorLine.bg = "#0f0f0f"
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

local treesitter_languages = {
  "lua",
  "python",
  "go",
  "gomod",
  "gowork",
  "javascript",
  "typescript",
  "tsx",
}

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    if event.data.spec.name == "nvim-treesitter"
        and event.data.kind == "update" then
      if not event.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end

      require("nvim-treesitter")
        .update(treesitter_languages)
        :wait(300000)
    end
  end,
})

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
}, { confirm = false })

local treesitter = require("nvim-treesitter")
treesitter.setup({})
treesitter.install(treesitter_languages):wait(300000)

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
}, { confirm = false })

vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1"),
  },
}, { confirm = false })

require("blink.cmp").setup({
  keymap = {
    preset = "enter",

    ["<Tab>"] = {
      "select_next",
      "snippet_forward",
      "fallback",
    },

    ["<S-Tab>"] = {
      "select_prev",
      "snippet_backward",
      "fallback",
    },
  },

  completion = {
    list = {
      selection = {
        preselect = false,
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 50,
    },
    ghost_text = {
      enabled = true,
    },
  },

  signature = {
    enabled = true,
  },

  sources = {
    default = {
      "lsp",
      "path",
      "snippets",
      "buffer",
    },
  },

  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
})

vim.pack.add({
  "https://codeberg.org/mfussenegger/nvim-dap",
  "https://github.com/leoluz/nvim-dap-go",
}, { confirm = false })

require("dap-go").setup()

-- Debug controls are active only while a debug session is running.
local dap = require("dap")
local map = vim.keymap.set
map("n", "<leader>ds", dap.continue)
map("n", "<leader>db", dap.toggle_breakpoint)
map("n", "<leader>dr", dap.repl.open)
map("n", "<leader>dq", dap.terminate)
map("n", "<leader>dt", function()
  require("dap-go").debug_test()
end)

-- Sets debugging keys when debugger starts
local saved_debug_keys
local function get_global_mapping(key)
  return vim.iter(vim.api.nvim_get_keymap("n")):find(function(mapping)
    return mapping.lhs == key
  end)
end

local function restore_debug_key(key)
  vim.keymap.del("n", key)
  if saved_debug_keys[key] then
    vim.fn.mapset("n", false, saved_debug_keys[key])
  end
end

local function map_debug_keys()
  -- guard for double call
  if saved_debug_keys then
    return
  end

  saved_debug_keys = {
    ["<Up>"] = get_global_mapping("<Up>"),
    ["<Down>"] = get_global_mapping("<Down>"),
    ["<Left>"] = get_global_mapping("<Left>"),
    ["<Right>"] = get_global_mapping("<Right>"),
  }
  map("n", "<Up>", dap.continue, { desc = "Debug: continue" })
  map("n", "<Down>", dap.step_over, { desc = "Debug: step over" })
  map("n", "<Left>", dap.step_out, { desc = "Debug: step out" })
  map("n", "<Right>", dap.step_into, { desc = "Debug: step in" })
end

local function unmap_debug_keys()
  if not saved_debug_keys then
    return
  end

  restore_debug_key("<Up>")
  restore_debug_key("<Down>")
  restore_debug_key("<Left>")
  restore_debug_key("<Right>")

  saved_debug_keys = nil
end

dap.listeners.after.event_initialized["debug_keys"] = map_debug_keys
dap.listeners.before.event_exited["debug_keys"] = unmap_debug_keys
dap.listeners.before.event_terminated["debug_keys"] = unmap_debug_keys

-- dap UI setup
vim.pack.add({
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/rcarriga/nvim-dap-ui",
}, { confirm = false })

local dapui = require("dapui")
dapui.setup({
  layouts = {
    {
     elements = {
       { id = "scopes", size = 0.50 },
       { id = "watches", size = 0.50 },
     },
     size = 60,
     position = "right",
   },
  },
  controls = {
   enabled = false,
  },
  expand_lines = false,
  wrap = true,
})

dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
dap.listeners.after.event_terminated["dapui"] = function() dapui.close() end
dap.listeners.after.event_exited["dapui"] = function() dapui.close() end

map("n", "<leader>du", function() dapui.toggle() end, { desc = "Debug: toggle UI" })
