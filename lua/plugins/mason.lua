return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"pyright",
				"ts_ls",
				"html",
				"cssls",
				"clangd",
				"sqlls",
			},
		})
	end,
}