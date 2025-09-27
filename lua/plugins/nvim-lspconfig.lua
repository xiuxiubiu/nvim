return {
	"neovim/nvim-lspconfig",
	config = function()
		local util = require("lspconfig/util")

		-- ccls
		vim.lsp.enable("clangd")

		-- typescript-language-server
		vim.lsp.enable("ts_ls")

		-- python
		vim.lsp.enable("pyright")

		-- tailwindcss
		vim.lsp.config("tailwindcss", {
			filetypes = {
				"aspnetcorerazor",
				"astro",
				"astro-markdown",
				"blade",
				"clojure",
				"django-html",
				"htmldjango",
				"edge",
				"eelixir",
				"elixir",
				"ejs",
				"erb",
				"eruby",
				"gohtml",
				"gohtmltmpl",
				"haml",
				"handlebars",
				"hbs",
				"html",
				"html-eex",
				"heex",
				"jade",
				"leaf",
				"liquid",
				"markdown",
				"mdx",
				"mustache",
				"njk",
				"nunjucks",
				"php",
				"razor",
				"slim",
				"twig",
				"less",
				"postcss",
				"sass",
				"scss",
				"stylus",
				"sugarss",
				"javascript",
				"javascriptreact",
				"reason",
				"rescript",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
				"templ",
			},
		})

		-- html
		vim.lsp.enable("html")

		-- css
		vim.lsp.config("cssls", {
			settings = {
				css = { validatee = true, lint = { unknownAtRules = "ignore" } },
				scss = { validatee = true, lint = { unknownAtRules = "ignore" } },
				less = { validatee = true, lint = { unknownAtRules = "ignore" } },
			},
		})

		-- sql
		vim.lsp.enable("sqlls")

		-- vue
		vim.lsp.enable("vue_ls")
	end,
}
