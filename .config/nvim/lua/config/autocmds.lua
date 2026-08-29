local group = vim.api.nvim_create_augroup("arya_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight copied text",
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = group,
  desc = "Reload files changed outside Neovim",
  command = "checktime",
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "lua",
    "python",
    "go",
    "gomod",
    "gowork",
    "javascript",
    "typescript",
    "typescriptreact",
  },
  desc = "Enable Tree-sitter highlighting",
  callback = function()
    vim.treesitter.start()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "lua",
    "typescript",
    "typescriptreact",
  },
  desc = "Use two-space indentation",
  callback = function(event)
    vim.bo[event.buf].expandtab = true
    vim.bo[event.buf].tabstop = 2
    vim.bo[event.buf].shiftwidth = 2
    vim.bo[event.buf].softtabstop = 2
  end,
})
