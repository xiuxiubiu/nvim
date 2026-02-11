return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				file_ignore_patterns = {
					"^target/",
					"^docs/",
				},
			},
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
		})

		-- Keybindings
		local map = vim.keymap.set
		map("n", "ts", builtin.live_grep, { desc = "Telescope live grep" })
		map("n", "tf", builtin.find_files, { desc = "Telescope find files" })
		map("n", "tg", builtin.git_branches, { desc = "Telescope git branches" })
		map("n", "tb", builtin.buffers, { desc = "Telescope buffers" })
		map("n", "tr", builtin.resume, { desc = "Telescope resume" })
	end,
}