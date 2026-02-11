return {
	"mrcjkb/rustaceanvim",
	version = "^5",
	lazy = false,
	init = function()
		vim.g.rustaceanvim = {
			tools = {
				float_win_config = {
					auto_focus = true,
				},
			},
			server = {
				on_attach = function(client, bufnr)
					-- register_cap(client, bufnr)
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						checkOnSave = {
							command = "clippy",
						},
						cargo = {
							allFeatures = true,
						},
						procMacro = {
							enable = true,
						},
					},
				},
			},
		}
	end,
}