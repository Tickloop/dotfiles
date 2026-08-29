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
    exclude = { "node_modules" },
    focus = "list",
    hidden = true,
    layout = { preset = "default" },
    matcher = {
      fuzzy = true,
      sort_empty = false,
    },
    win = {
      input = {
        keys = {
          ["<C-/>"] = { "toggle_focus", mode = { "n", "i" } },
        },
      },
      list = {
        keys = {
          ["<C-/>"] = "toggle_focus",
        },
      },
    },
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

-- Linux uses Control combinations in place of the macOS F13 layer.
map(action_modes, "<C-p>", tree_open, { desc = "Project Tree" })
map(action_modes, "<C-S-p>", quick_open, { desc = "Quick Open" })
map(action_modes, "<C-f>", find_in_file, { desc = "Find in File" })
map(action_modes, "<C-S-f>", find_in_files, { desc = "Find in Files" })
map(action_modes, "<C-b>", buffer_picker, { desc = "Open Buffer" })
map(action_modes, "<C-S-b>", "<cmd>bdelete<cr>", { desc = "Close Buffer" })
map(action_modes, "<C-S-w>", "<cmd>bdelete<cr>", { desc = "Close Editor" })
map(action_modes, "<C-s>", "<cmd>update<cr><esc>", { desc = "Save File" })
map(action_modes, "<C-n>", "<cmd>enew<cr>", { desc = "New File" })
map(action_modes, "<C-\\>", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
map(action_modes, "<C-->", "<cmd>split<cr>", { desc = "Horizontal Split" })
map("n", "<C-w>", "<cmd>close<cr>", { desc = "Close Window" })
map(action_modes, "<C-t>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- <C-[> is Escape outside normal mode, so this one cannot use action_modes.
map("n", "<C-[>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map(action_modes, "<C-]>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map(action_modes, "<C-q>", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map(action_modes, "<C-S-e>", "<cmd>Explore<cr>", { desc = "Open Explorer" })
map(terminal_toggle_modes, "<C-S-;>", floating_terminal, { desc = "Toggle Floating Terminal" })

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


-- MARK: code naviation config
local function toggle_hover_docs()
  local buffer = vim.api.nvim_get_current_buf()
  local preview = vim.b[buffer].lsp_floating_preview

  if preview and vim.api.nvim_win_is_valid(preview) then
    vim.api.nvim_win_close(preview, true)
    return
  end

  vim.lsp.buf.hover({
    border = "rounded"
  })
end

local function peek_implementations()
  require("fzf-lua").lsp_implementations({
    jump1 = false,
  })
end

local function peek_type_definitions()
  require("fzf-lua").lsp_typedefs({
    jump1 = false,
  })
end

local function list_references()
  local source_window = vim.api.nvim_get_current_win()
  vim.lsp.buf.references(nil, {
    on_list = function(list)
      if vim.api.nvim_win_is_valid(source_window) then
        vim.fn.setloclist(source_window, {}, " ", list)
      end
    end,
  })
  require("fzf-lua").lsp_references({
    jump1 = false,
  })
end

local function cycle_references(offset)
  local list = vim.fn.getloclist(0, {
    idx = 0,
    size = 0,
  })

  if list.size == 0 then
    vim.notify("No cached references", vim.log.levels.INFO)
    return
  end

  local current = math.max(list.idx, 1)
  local target = ((current - 1 + offset) % list.size) + 1

  vim.cmd(target .. "ll")
end

local diagnostic_severities = {
  vim.diagnostic.severity.ERROR,
  vim.diagnostic.severity.WARN,
}

local function show_diagnostic()
  local buffer = vim.api.nvim_get_current_buf()
  local preview = vim.b[buffer].lsp_floating_preview

  if preview and vim.api.nvim_win_is_valid(preview) then
    vim.api.nvim_win_close(preview, true)
    return
  end

  vim.diagnostic.open_float({
    scope = "cursor",
    focus = false,
    border = "rounded",
    severity = diagnostic_severities,
  })
end

local function list_diagnostics()
  require("fzf-lua").diagnostics_document()
end

local diagnostic_float_options = {
  border = "rounded",
  focus = false,
}

local function next_diagnostic()
  vim.diagnostic.jump({
    count = 1,
    float = diagnostic_float_options,
    severity = diagnostic_severities,
  })
end

local function previous_diagnostic()
  vim.diagnostic.jump({
    count = -1,
    float = diagnostic_float_options,
    severity = diagnostic_severities,
  })
end

map("n", "<C-u>", "<C-o>", { desc = "Navigate Backward" })
map("n", "<C-o>", "<C-i>", { desc = "Navigate Forward" })
map("n", "<C-i>", "<C-u>", { desc = "Navigate Upward by half screen" })
map("n", "<C-S-i>", "<C-d>", { desc = "Navigate Downward by half screen" })

map("n", "gk", toggle_hover_docs, { desc = "Toggle Documentation" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Show Function signature" })

map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

map("n", "gi", peek_implementations, { desc = "Peek Implementations" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })

map("n", "gt", peek_type_definitions, { desc = "Peek Type Definitions" })
map("n", "gT", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })

-- Replace Neovim's default gr-prefixed LSP mappings with a smaller set.
for _, lhs in ipairs({ "grn", "grr", "gri", "grt", "grx" }) do
  vim.keymap.del("n", lhs)
end
vim.keymap.del("n", "gra")
vim.keymap.del("x", "gra")

map("n", "gr", list_references, { desc = "List References" })
map("n", "]r", function() cycle_references(1) end, { desc = "Next Reference" })
map("n", "[r", function() cycle_references(-1) end, { desc = "Previous Reference" })

map({ "n", "x" }, "ga", vim.lsp.buf.code_action, { desc = "Code Actions" })
map("n", "gn", vim.lsp.buf.rename, { desc = "Rename Symbol" })

map("n", "gw", show_diagnostic, { desc = "Show Diagnostic" })
map("n", "ge", list_diagnostics, { desc = "List File Diagnostics" })
map("n", "]w", next_diagnostic, { desc = "Next Diagnostic" })
map("n", "[w", previous_diagnostic, { desc = "Previous Diagnostic" })

-- keeps text selected after indent actions
map("x", ">", ">gv", { desc = "Indent and Reselect" })
map("x", "<", "<gv", { desc = "Outdent and Reselect" })

-- makes shift+nav work like selection
map("n", "H", "Vh", { desc = "Select Left" })
map("n", "J", "Vj", { desc = "Select Down" })
map("n", "K", "Vk", { desc = "Select Up" })
map("n", "L", "Vl", { desc = "Select Right" })

map("x", "H", "h", { desc = "Extend Selection Left" })
map("x", "J", "j", { desc = "Extend Selection Down" })
map("x", "K", "k", { desc = "Extend Selection Up" })
map("x", "L", "l", { desc = "Extend Selection Right" })
