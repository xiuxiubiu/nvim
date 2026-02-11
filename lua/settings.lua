local opt = vim.opt

-- General Settings
opt.termguicolors = true
opt.hlsearch = true
opt.number = true
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
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.cmd("checktime")
	end,
})

-- Change input method to English when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.fn.system("/usr/local/bin/im-select com.apple.keylayout.ABC")
	end,
})

-- Diagnostic configuration
vim.diagnostic.config({
	float = { border = "single" },
})

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
	vim.lsp.buf.hover({ border = "single" })
end, { desc = "LSP Hover" })
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