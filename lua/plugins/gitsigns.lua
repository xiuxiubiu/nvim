return {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	config = function()
		local gs = require("gitsigns")
		gs.setup({})

		-- Keybindings
		local map = vim.keymap.set
		map("n", "g]", gs.next_hunk, { desc = "Next Git hunk" })
		map("n", "g[", gs.prev_hunk, { desc = "Previous Git hunk" })
		map("n", "gd", gs.diffthis, { desc = "Git diff this" })
		map("n", "gi", function()
			gs.blame_line({ full = true })
		end, { desc = "Git blame line" })
	end,
}