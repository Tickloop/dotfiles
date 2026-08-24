local group = vim.api.nvim_create_augroup("arya_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight copied text",
  callback = function()
    vim.hl.on_yank()
  end,
})
