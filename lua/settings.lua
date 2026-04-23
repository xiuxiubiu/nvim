local opt = vim.opt

-- General Settings
opt.termguicolors = true
opt.hlsearch = true
opt.number = true
opt.fillchars = { eob = " " }
opt.tabstop = 4
opt.sw = 4
opt.mouse = ""
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.formatoptions = "r"
opt.splitbelow = true
opt.splitright = true
opt.shell = "/bin/zsh"

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	callback = function()
		vim.schedule(function()
			vim.cmd("checktime")
		end)
	end,
})

-- Change input method to English when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.fn.system("/usr/local/bin/im-select com.apple.keylayout.ABC")
	end,
})

-- 2-space indentation for frontend files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "javascript", "json", "html", "css", "tsx", "typescriptreact", "jsx", "javascriptreact", "vue", "yaml", "xml" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.autoindent = true
	end,
})

-- Diagnostic configuration
vim.diagnostic.config({
	float = { border = "rounded" },
})

-- Neovim 0.12.1: injection queries can yield matches where the node is nil or
-- a non-TSNode value, crashing get_range with
-- "attempt to call method 'range' (a nil value)". Swallow any failure and
-- return an empty range so parsing can continue for other captures.
-- Installed here (before plugins) to beat the first treesitter parse.
do
	local orig_get_range = vim.treesitter.get_range
	vim.treesitter.get_range = function(node, source, metadata)
		local ok, result = pcall(orig_get_range, node, source, metadata)
		if ok then
			return result
		end
		return { 0, 0, 0, 0, 0, 0 }
	end
end

-- General Keybindings
local map = vim.keymap.set

-- Buffers
map("n", "]", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "[", "<cmd>bp<cr>", { desc = "Previous buffer" })
map("n", "<C-c>", "<cmd>bd<cr>", { desc = "Close buffer" })
map("n", "<C-q>", "<cmd>q<cr>", { desc = "Quit" })

-- LSP Keybindings (Generic)
map("n", "'rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
map("n", "'ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "'g", vim.lsp.buf.definition, { desc = "LSP Definition" })
map("n", "'rf", vim.lsp.buf.references, { desc = "LSP References" })
map("n", "'h", function()
	vim.lsp.buf.hover({ border = "rounded", max_height = 100, max_width = 120 })
end, { desc = "LSP Hover" })
map("n", "'s", function()
	vim.lsp.buf.signature_help({ border = "rounded", max_height = 15, max_width = 80 })
end, { desc = "LSP Signature Help" })
map("n", "'ei", vim.diagnostic.open_float, { desc = "Diagnostic Float" })
map("n", "'el", vim.diagnostic.setloclist, { desc = "Diagnostic Loclist" })
map("n", "'ep", function()
	vim.diagnostic.goto_prev()
	vim.diagnostic.open_float()
end, { desc = "Previous Diagnostic" })
map("n", "'en", function()
	vim.diagnostic.goto_next()
	vim.diagnostic.open_float()
end, { desc = "Next Diagnostic" })

-- Tree
map("n", "\\", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })

-- Fold
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Sign for DAP
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "", linehl = "", numhl = "" })

