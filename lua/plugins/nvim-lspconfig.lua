return {
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")
		local util = require("lspconfig/util")

		-- ccls
		lspconfig.clangd.setup({})

		-- gopls
		lspconfig.gopls.setup({
			cmd = { "gopls", "serve" },
			filetypes = { "go", "gomod" },
			root_dir = util.root_pattern("go.work", "go.mod", ".git"),
			settings = {
				gopls = {
					analyses = { unusedparams = true },
					-- staticcheck = true,
					hoverKind = "FullDocumentation",
					codelenses = { upgrade_dependency = true },
					-- allowModfileModifications = true,
				},
			},
		})

		-- lua-language-server
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = { enable = false },
				},
			},
		})

		-- typescript-language-server
		lspconfig.ts_ls.setup({})

		-- python
		lspconfig.pyright.setup({})

		-- tailwindcss
		lspconfig.tailwindcss.setup({
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
		lspconfig.html.setup({})

		-- css
		lspconfig.cssls.setup({
			settings = {
				css = { validatee = true, lint = { unknownAtRules = "ignore" } },
				scss = { validatee = true, lint = { unknownAtRules = "ignore" } },
				less = { validatee = true, lint = { unknownAtRules = "ignore" } },
			},
		})

		-- sql
		lspconfig.sqlls.setup({})

		-- vue
		-- lspconfig.vuels.setup({})
		lspconfig.volar.setup({})

		-- jdtls
		-- lspconfig.jdtls.setup {}

		-- swift
		-- lspconfig.sourcekit.setup {
		--     root_dir = function(filename, _)
		--         return util.root_pattern 'buildServer.json'(filename) or
		--                    util.root_pattern('*.xcodeproj', '*.xcworkspace')(
		--                        filename) -- better to keep it at the end, because some modularized apps contain multiple Package.swift files
		--         or
		--                    util.root_pattern('compile_commands.json',
		--                                      'Package.swift')(filename) or
		--                    util.find_git_ancestor(filename) or
		--                    util.root_pattern '*.swift'(filename)
		--     end,
		--     capabilities = {
		--         workspace = {
		--             didChangeWatchedFiles = {dynamicRegistration = true}
		--         }
		--     }
		-- }
	end,
}
