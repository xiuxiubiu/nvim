return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local spectre = require("spectre")
		local map = vim.keymap.set

		spectre.setup()

		map("n", "<C-s>", function()
			spectre.open_visual({ select_word = true })
		end, { desc = "Spectre Open (word)" })
		map("n", "Rr", function()
			require("spectre.actions").run_replace()
		end, { desc = "Spectre Run Replace" })
		map("n", "Rcr", function()
			require("spectre.actions").run_current_replace()
		end, { desc = "Spectre Run Current Replace" })
	end,
}