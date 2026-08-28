vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "standard",
			},
		},
	},
})


vim.lsp.enable({
  "gopls",
  "basedpyright",
  "ts_ls",
})
