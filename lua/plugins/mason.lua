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
				"html",
				"cssls",
				"clangd",
				"sqlls",
			},
			-- 已安装但启用会与 pyright 重复(导致 gd/gr 结果翻倍):
			-- pylsp 用不到的话也可以直接 :MasonUninstall python-lsp-server
			automatic_enable = {
				exclude = { "pylsp", "ts_ls" },
			},
		})
	end,
}
