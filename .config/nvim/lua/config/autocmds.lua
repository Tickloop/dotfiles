local group = vim.api.nvim_create_augroup("arya_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight copied text",
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "lua" },
  desc = "Enable Tree-sitter highlighting for Lua",
  callback = function()
    vim.treesitter.start()
  end,
})
