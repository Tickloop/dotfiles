local map = vim.keymap.set
local silent = { silent = true }

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
        vim.keymap.set("t", "<C-\\>", "<C-v>", {
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
  vim.print("running floating terminal!")
  require("snacks").terminal.toggle(nil, {
    cwd = project_root(),
    win = {
      border = "rounded",
      height = 0.80,
      position = "float",
      width = 0.80,
    },
  })
end

-- map("n", "<C-p>", quick_open, { desc = "Quick Open" })
-- map("n", "<C-S-p>", command_palette, { desc = "Command Palette" })
-- map("n", "<C-f>", find_in_file, { desc = "Find in File" })
-- map("n", "<C-S-f>", find_in_files, { desc = "Find in Files" })
-- map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>update<cr><esc>", { desc = "Save File" })
-- map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New File" })

-- Keep <C-w> as Neovim's window-command prefix; use Shift to close a buffer.
map("n", "<C-S-w>", "<cmd>bdelete<cr>", { desc = "Close Editor" })

-- Custom VS Code shortcuts
map("n", "<C-S-e>", "<cmd>Explore<cr>", { desc = "Open Explorer" })

-- Karabiner sends these F13 sequences for Neovim-specific actions.
map("n", "<C-p>", tree_open, { desc = "Project Tree" })
map("n", "<C-S-p>", command_palette, { desc = "Command Palette" })
map("n", "<C-f>", find_in_file, { desc = "Find in File" })
map("n", "<C-S-f>", find_in_files, { desc = "Find in Files" })
map("n", "<C-b>", buffer_picker, { desc = "Open Buffer" })
map("n", "<C-S-b>", "<cmd>bdelete<cr>", { desc = "Close Buffer" })
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>update<cr><esc>", { desc = "Save File" })
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<C-\\>", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
map("n", "<C-->", "<cmd>split<cr>", { desc = "Horizontal Split" })
map("n", "<C-w>", "<cmd>close<cr>", { desc = "Close Window" })
map("n", "<C-t>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<C-[>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<C-]>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<C-q>", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<C-S-e>", "<cmd>Explore<cr>", { desc = "Open Explorer" })
map({ "n", "t" }, "<C-S-;>", floating_terminal, { desc = "Toggle Floating Terminal" })

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
