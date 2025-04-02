return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		-- "hrsh7th/cmp-cmdline", -- For vsnip users.
		-- "hrsh7th/cmp-vsnip",
		-- "hrsh7th/vim-vsnip", -- For luasnip users.
		-- "L3MON4D3/LuaSnip",
		-- "saadparwaiz1/cmp_luasnip", -- For ultisnips users.
		-- "SirVer/ultisnips",
		-- "quangnguyen30192/cmp-nvim-ultisnips",

		-- For snippy users.
		-- "dcampos/nvim-snippy",
		-- "dcampos/cmp-snippy",
	},
	config = function()
		-- Setup nvim-cmp.
		local cmp = require("cmp")

		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					vim.snippet.expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
				hover = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
						-- elseif vim.fn["vsnip#available"]() == 1 then
						-- 	feedkey("<Plug>(vsnip-expand-or-jump)", "")
					elseif has_words_before() then
						cmp.complete()
					else
						fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				-- { name = "vsnip" }, -- For vsnip users.
				-- { name = 'luasnip' }, -- For luasnip users.
				-- { name = 'ultisnips' }, -- For ultisnips users.
				-- { name = 'snippy' }, -- For snippy users.
			}, { { name = "buffer" } }),
			preselect = cmp.PreselectMode.None,
			sorting = {
				comparators = {
					cmp.config.compare.length,
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.kind, -- cmp.config.compare.sort_text,
					cmp.config.compare.order,
				},
			},
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
			}, { { name = "buffer" } }),
		})

		-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = { { name = "buffer" } },
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
		})

		-- Setup lspconfig.
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- local on_attach = function(client, bufnr)
		-- 	local function buf_set_keymap(...)
		-- 		vim.api.nvim_buf_set_keymap(bufnr, ...)
		-- 	end
		-- 	local function buf_set_option(...)
		-- 		vim.api.nvim_buf_set_option(bufnr, ...)
		-- 	end
		--
		-- 	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
		-- end

		-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
		-- require('lspconfig')['clangd'].setup {capabilities = capabilities}
		require("lspconfig")["ccls"].setup({ capabilities = capabilities })

		require("lspconfig")["html"].setup({ capabilities = capabilities })

		-- sql
		require("lspconfig")["sqlls"].setup({ capabilities = capabilities })

		-- swift
		require("lspconfig")["sourcekit"].setup({ capabilities = capabilities })

		-- rust
		require("lspconfig")["rust_analyzer"].setup({
			capabilities = capabilities,
		})

		-- ts
		require("lspconfig")["ts_ls"].setup({ capabilities = capabilities })

		-- python
		require("lspconfig")["pyright"].setup({ capabilities = capabilities })

		-- GoLang
		require("lspconfig")["gopls"].setup({
			cmd = { "gopls" },
			-- on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				gopls = {
					experimentalPostfixCompletions = true,
					analyses = {
						unusedparams = true,
						shadow = true,
					},
					staticcheck = true,
				},
			},
			init_options = {
				usePlaceholders = true,
			},
		})
	end,
}
