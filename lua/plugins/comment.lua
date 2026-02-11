return {
	"numToStr/Comment.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		local comment = require("Comment")
		local api = require("Comment.api")

		comment.setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})

		-- Keybindings
		local map = vim.keymap.set
		map({ "n", "i" }, "<C-/>", function()
			api.toggle.linewise.current()
			vim.cmd("normal $")
		end, { desc = "Toggle Comment" })

		map("x", "<C-/>", function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", false)
			api.toggle.linewise(vim.fn.visualmode())
			vim.cmd("normal $")
		end, { desc = "Toggle Comment (Visual)" })
	end,
}