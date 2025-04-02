return {
	"mfussenegger/nvim-dap-python",
	dependencies = { "mfussenegger/nvim-dap", "neovim/nvim-lspconfig" },
	config = function()
		local util = require("lspconfig.util")
		local root_files = {
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			"pyrightconfig.json",
			".git",
		}
		require("dap-python").setup("python3")
	end,
}
