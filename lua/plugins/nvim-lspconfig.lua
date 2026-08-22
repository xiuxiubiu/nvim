return {
	"neovim/nvim-lspconfig",
	config = function()
		local util = require("lspconfig/util")

		-- ccls
		vim.lsp.enable("clangd")

		-- TypeScript 7 native language server. nvim-lspconfig resolves the
		-- workspace-local node_modules/.bin/tsc before falling back to PATH.
		vim.lsp.enable("tsc")

		-- python
		-- 存在 .venv(uv/poetry/pdm 的约定位置)时,显式指定解释器,
		-- 否则 pyright 回退到系统 python,venv 独有的第三方包全部 reportMissingImports。
		-- 注意:必须【原地修改】config.settings。若用 vim.tbl_deep_extend 重新赋值,
		-- Neovim 发给服务器的 client.settings 仍指向旧表,pythonPath 永远不会生效。
		vim.lsp.config("pyright", {
			before_init = function(_, config)
				local root = config.root_dir
				if not root then
					return
				end
				-- 从 root_dir 向上找最近的 .venv,覆盖两种布局:
				-- 1. venv 与 pyproject.toml 同级(最常见);
				-- 2. pyproject.toml 在子目录、venv 在 monorepo 顶层。
				-- 遇到 .git(仓库边界)就停,避免误用仓库外不相干的 venv。
				local dir = root
				while dir do
					local python = dir .. "/.venv/bin/python"
					if vim.fn.executable(python) == 1 then
						config.settings = config.settings or {}
						config.settings.python = config.settings.python or {}
						config.settings.python.pythonPath = python
						break
					end
					if vim.uv.fs_stat(dir .. "/.git") then
						break
					end
					local parent = vim.fs.dirname(dir)
					if parent == dir then
						break
					end
					dir = parent
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
