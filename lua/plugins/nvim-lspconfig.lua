return {
	"neovim/nvim-lspconfig",
	config = function()
		local util = require("lspconfig/util")

		-- ccls
		vim.lsp.enable("clangd")

		-- typescript-language-server
		vim.lsp.enable("ts_ls")

		-- python
		-- 项目根下存在 .venv(uv/poetry/pdm 的约定位置)时,显式指定解释器,
		-- 否则 pyright 用系统 python,第三方包全部 reportMissingImports
		vim.lsp.config("pyright", {
			before_init = function(_, config)
				local root = config.root_dir
				if root then
					local venv = root .. "/.venv/bin/python"
					if vim.fn.executable(venv) == 1 then
						config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
							python = { pythonPath = venv },
						})
					end
				end
			end,
		})
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
