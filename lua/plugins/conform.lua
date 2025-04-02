return {
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				swift = { "swiftformat" },
				lua = { "stylua" },
				go = { "goimports" },
				rust = { "rustfmt" },
				-- python = { "yapf" },
				python = { "black" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				vue = { "prettier" },
				typescript = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
			},
			format_on_save = function(bufnr)
				local ignore_filetypes = { "oil" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end

				return { timeout_ms = 500, lsp_fallback = true }
			end,
			log_level = vim.log.levels.ERROR,
		})
	end,
	"stevearc/conform.nvim",
}
