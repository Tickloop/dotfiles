local map = vim.keymap.set
local silent = { silent = true }

local function project_root()
  return vim.fs.root(0, { ".git", "package.json", "pyproject.toml", "lua" }) or vim.fn.getcwd()
end

-- MARK: Delete without yanking
map({ "n", "v" }, "d", '"_d')
map("n", "dd", '"_dd')
map({ "n", "v" }, "x", "d")
map("n", "xx", "dd")

-- MARK: Toggle fold
map("n", "zz", "za", { desc = "Toggle fold" })

-- MARK: VS Code shortcuts
-- Ghostty and Neovim support the extended keyboard protocol, so shifted
-- Control combinations remain distinct from their unshifted versions.
local function quick_open()
  require("fzf-lua").files({ cwd = project_root() })
end

local function command_palette()
  require("fzf-lua").commands()
end

local function find_in_file()
  require("fzf-lua").blines()
end

local function find_in_files()
  require("fzf-lua").live_grep({ cwd = project_root() })
end

map("n", "<C-p>", quick_open, { desc = "Quick Open" })
map("n", "<C-S-p>", command_palette, { desc = "Command Palette" })
map("n", "<C-f>", find_in_file, { desc = "Find in File" })
map("n", "<C-S-f>", find_in_files, { desc = "Find in Files" })
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>update<cr><esc>", { desc = "Save File" })
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New File" })

-- Keep <C-w> as Neovim's window-command prefix; use Shift to close a buffer.
map("n", "<C-S-w>", "<cmd>bdelete<cr>", { desc = "Close Editor" })

-- Custom VS Code shortcuts
map("n", "<C-S-e>", "<cmd>Explore<cr>", { desc = "Open Explorer" })

-- Karabiner sends these F13 sequences for Neovim-specific actions.
map("n", "<F13>p", quick_open, { desc = "Quick Open" })
map("n", "<F13>P", command_palette, { desc = "Command Palette" })
map("n", "<F13>f", find_in_file, { desc = "Find in File" })
map("n", "<F13>F", find_in_files, { desc = "Find in Files" })
map({ "n", "i", "x", "s" }, "<F13>s", "<cmd>update<cr><esc>", { desc = "Save File" })
map("n", "<F13>n", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<F13>w", "<cmd>bdelete<cr>", { desc = "Close Editor" })
map("n", "<F13>E", "<cmd>Explore<cr>", { desc = "Open Explorer" })

-- Window navigation. <C-w> remains available for every built-in window command.
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", silent, { desc = "Window left" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", silent, { desc = "Window down" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", silent, { desc = "Window up" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", silent, { desc = "Window right" }))
