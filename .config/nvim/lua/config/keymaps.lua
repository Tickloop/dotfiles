local map = vim.keymap.set
local silent = { silent = true }
local action_modes = { "n", "i", "x", "s" }
local terminal_toggle_modes = { "n", "i", "x", "s", "t" }

local function project_root()
  return vim.fs.root(0, { ".git", "package.json", "pyproject.toml", "lua" }) or vim.fn.getcwd()
end


-- MARK: VS Code shortcuts
-- Ghostty and Neovim support the extended keyboard protocol, so shifted
-- Control combinations remain distinct from their unshifted versions.
local function quick_open()
  require("fzf-lua").files({ cwd = project_root() })
end

local function tree_open()
  require("snacks").picker.explorer({
    auto_close = true,
    cwd = project_root(),
    focus = "input",
    hidden = true,
    layout = { preset = "default" },
  })
end

local function smart_buffer_switch(selected, opts)
  if not selected[1] then
    return
  end

  local entry = require("fzf-lua.path").entry_to_file(selected[1], opts)
  local current_tab = vim.api.nvim_get_current_tabpage()
  local tabpages = { current_tab }

  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    if tabpage ~= current_tab then
      table.insert(tabpages, tabpage)
    end
  end

  if entry.bufnr and vim.api.nvim_buf_is_valid(entry.bufnr) then
    for _, tabpage in ipairs(tabpages) do
      for _, window in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
        if vim.api.nvim_win_get_buf(window) == entry.bufnr then
          vim.api.nvim_set_current_tabpage(tabpage)
          vim.api.nvim_set_current_win(window)
          return
        end
      end
    end
  end

  require("fzf-lua.actions").buf_edit(selected, opts)
end

local function buffer_picker()
  local actions = require("fzf-lua.actions")

  require("fzf-lua").buffers({
    actions = {
      ["enter"] = smart_buffer_switch,
      ["ctrl-v"] = actions.buf_vsplit,
    },
    winopts = {
      on_create = function(event)
        vim.keymap.set("t", "<F13>\\", "<C-v>", {
          buffer = event.bufnr,
          desc = "Open Buffer in Vertical Split",
          nowait = true,
          silent = true,
        })
      end,
    },
  })
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

local function floating_terminal()
  require("snacks").terminal.toggle(nil, {
    cwd = project_root(),
    win = {
      border = "rounded",
      height = 0.85,
      position = "float",
      width = 0.90,
    },
  })
end

-- Karabiner sends these F13 sequences for Neovim-specific actions.
map(action_modes, "<F13>p", tree_open, { desc = "Project Tree" })
map(action_modes, "<F13>P", command_palette, { desc = "Command Palette" })
map(action_modes, "<F13>f", find_in_file, { desc = "Find in File" })
map(action_modes, "<F13>F", find_in_files, { desc = "Find in Files" })
map(action_modes, "<F13>b", buffer_picker, { desc = "Open Buffer" })
map(action_modes, "<F13>s", "<cmd>update<cr><esc>", { desc = "Save File" })
map(action_modes, "<F13>n", "<cmd>enew<cr>", { desc = "New File" })
map(action_modes, "<F13>\\", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
map(action_modes, "<F13>-", "<cmd>split<cr>", { desc = "Horizontal Split" })
map(action_modes, "<F13>w", "<cmd>bdelete<cr>", { desc = "Close Buffer" })
map(action_modes, "<F13>t", "<cmd>tabnew<cr>", { desc = "New Tab" })
map(action_modes, "<F13>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map(action_modes, "<F13>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map(action_modes, "<F13>q", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map(action_modes, "<F13>E", "<cmd>Explore<cr>", { desc = "Open Explorer" })
map(terminal_toggle_modes, "<F13>:", floating_terminal, { desc = "Toggle Floating Terminal" })

-- Window navigation. <C-w> remains available for every built-in window command.
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", silent, { desc = "Window left" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", silent, { desc = "Window down" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", silent, { desc = "Window up" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", silent, { desc = "Window right" }))


-- MARK: Delete without yanking
map({ "n", "v" }, "d", '"_d')
map("n", "dd", '"_dd')
map({ "n", "v" }, "x", "d")
map("n", "xx", "dd")

-- MARK: Toggle fold
map("n", "zz", "za", { desc = "Toggle fold" })

-- ESC out of search
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Close search highlight" })
