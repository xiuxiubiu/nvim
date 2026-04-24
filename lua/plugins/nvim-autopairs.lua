return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	lazy = false,
	config = function()
		local npairs = require("nvim-autopairs")
		npairs.setup({})
		-- Integrate with nvim-cmp to add () on function completion
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
