local group = vim.api.nvim_create_augroup("arya_lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  desc = "Add Linux LSP shortcuts that avoid Ctrl conflicts",
  callback = function(event)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      buffer = event.buf,
      desc = "Go to Definition",
    })
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, {
      buffer = event.buf,
      desc = "Signature Help",
    })
  end,
})

vim.lsp.enable({
  "gopls",
  "basedpyright",
  "ts_ls",
})
