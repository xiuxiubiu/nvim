local api = vim.api
local g = vim.g
local opt = vim.opt
local fn = vim.fn
-- local util = vim.util

-- breakpoint
fn.sign_define("DapBreakpoint", { text = "●", texthl = "", linehl = "", numhl = "" })

opt.termguicolors = true -- Enable colors in termimal
opt.hlsearch = true -- Set highlight on search
opt.number = true -- Make line numbers default
opt.tabstop = 4 -- set ts=4
opt.sw = 4 -- set sw=4
opt.mouse = "" -- Enable mouse mode
opt.ignorecase = true -- Case insensitive searching unless /C or capital search
opt.signcolumn = "yes" -- Always show sign column
opt.clipboard = "unnamedplus" -- AAccess system clipboard opt.autochdir = true -- http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
opt.formatoptions = "r"
opt.splitbelow = true
opt.shell = "/bin/zsh"

-- Check if we need to reload the file when it changed
api.nvim_create_autocmd("BufEnter", { command = [[:checktime]] })

-- autoformat
-- api.nvim_create_autocmd("BufWritePost", {
-- 	command = [[:FormatWrite]],
-- 	pattern = {
-- 		'*.go', '*.rs', "*.lua", "*.vue", "*.js", "*.ts", "*.html", "*.jsx",
-- 		"*.tsx", "*.json", "*.css", "*.java", "*.sql"
-- 	}
-- })

-- change english
api.nvim_create_autocmd("InsertLeave", {
	command = [[
		:lua vim.fn.system('/usr/local/bin/im-select com.apple.keylayout.ABC')
	]],
})

-- debug
api.nvim_set_keymap("n", "'d", '<cmd> lua require"dap".continue()<cr>', {})
api.nvim_set_keymap("n", "'b", '<cmd> lua require"dap".toggle_breakpoint()<cr>', { nowait = true })
api.nvim_set_keymap("n", "'cl", '<cmd> lua require"dap".clear_breakpoints()<cr>', { nowait = true })
api.nvim_set_keymap("n", "'t", '<cmd> lua require"dap".terminate()<cr>', { nowait = true })
api.nvim_set_keymap("n", "'ro", '<cmd> lua require"dap".repl.open()<cr>', { nowait = true })
api.nvim_set_keymap("n", "'rc", '<cmd> lua require"dap".repl.close()<cr>', { nowait = true })

-- dapui
api.nvim_set_keymap("n", "'ut", '<cmd> lua require"dapui".toggle()<cr>', { nowait = true })
api.nvim_set_keymap(
	"n",
	"'fe",
	'<cmd> lua require"dapui".float_element(nil, {width=200, height=40, enter=true})<cr>',
	{ nowait = true }
)
api.nvim_set_keymap("n", "'ue", '<cmd> lua require"dapui".eval()<cr>', { nowait = true })

-- lsp
vim.diagnostic.config({ float = { border = "single" } })
api.nvim_set_keymap("n", "'rn", "<cmd> lua vim.lsp.buf.rename()<cr>", { nowait = true })
api.nvim_set_keymap("n", "'ca", "<cmd> lua vim.lsp.buf.code_action()<cr>", { nowait = true })
api.nvim_set_keymap("n", "'g", "<cmd> lua vim.lsp.buf.definition()<cr>", { nowait = true })
api.nvim_set_keymap("n", "'rf", "<cmd> lua vim.lsp.buf.references()<cr>", { nowait = true })
api.nvim_set_keymap("n", "'ei", "<cmd> lua vim.diagnostic.open_float()<cr>", { nowait = true })
api.nvim_set_keymap("n", "'el", "<cmd> lua vim.diagnostic.setloclist()<cr>", { nowait = true })
api.nvim_set_keymap(
	"n",
	"'ep",
	"<cmd> lua vim.diagnostic.goto_prev()<cr><cmd> lua vim.diagnostic.open_float()<cr>",
	{ nowait = true }
)
api.nvim_set_keymap(
	"n",
	"'en",
	"<cmd> lua vim.diagnostic.goto_next()<cr><cmd> lua vim.diagnostic.open_float()<cr>",
	{ nowait = true }
)
api.nvim_set_keymap("n", "'h", "<cmd> lua vim.lsp.buf.hover()<cr>", { nowait = true })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	-- Use a sharp border with `FloatBorder` highlights
	border = "single",
})

-- buffers
api.nvim_set_keymap("n", "]", "<cmd> bn<cr>", { nowait = true })
api.nvim_set_keymap("n", "[", "<cmd> bp<cr>", { nowait = true })
for i = 1, 9, 1 do
	api.nvim_set_keymap("n", i .. "<cr>", "<cmd> BufferLineGoToBuffer " .. i .. "<cr>", { nowait = true })
end

-- nvim-tree
api.nvim_set_keymap("n", "\\", "<cmd> NvimTreeToggle<cr>", { nowait = true })
api.nvim_set_keymap("n", "<C-c>", "<cmd> bd<cr>", { nowait = true })
api.nvim_set_keymap("n", "<C-q>", "<cmd> q<cr>", { nowait = true })

-- toggleterm
api.nvim_set_keymap("n", "<C-;>", "<cmd> ToggleTerm<cr>", { nowait = true })
api.nvim_set_keymap("t", "<C-'>", "<cmd>tnoremap <Esc> <C-\\><C-n>", { nowait = true })

-- spectre
api.nvim_set_keymap("n", "<C-s>", '<cmd> lua require"spectre".open_visual({select_word = true})<cr>', { nowait = true })

-- Comment
api.nvim_set_keymap(
	"n",
	"<C-/>",
	'<cmd> lua require"Comment.api".toggle.linewise.current()<cr><cmd> normal $<cr>',
	{ nowait = true }
)
api.nvim_set_keymap(
	"i",
	"<C-/>",
	'<cmd> lua require"Comment.api".toggle.linewise.current()<cr><cmd> normal $<cr>',
	{ nowait = true }
)
api.nvim_set_keymap(
	"x",
	"<C-/>",
	'<esc><cmd>lua require"Comment.api".toggle.linewise(vim.fn.visualmode())<cr><cmd> normal $<cr>',
	{ nowait = true }
) -- {}
-- api.nvim_set_keymap('i', '{<cr>', '{<cr>}<esc>O', {nowait = true})

-- git
api.nvim_set_keymap("n", "g]", "<cmd>Gitsigns next_hunk<cr>", { nowait = true })
api.nvim_set_keymap("n", "g[", "<cmd>Gitsigns prev_hunk<cr>", { nowait = true })
api.nvim_set_keymap("n", "gd", "<cmd>Gitsigns diffthis<cr>", { nowait = true })
api.nvim_set_keymap("n", "gi", '<cmd>lua require"gitsigns".blame_line({full = true})<cr>', { nowait = true })

-- replace
api.nvim_set_keymap("n", "Rr", '<cmd>lua require"spectre.actions".run_replace()<cr>', { nowait = true })
api.nvim_set_keymap("n", "Rcr", '<cmd>lua require"spectre.actions".run_current_replace()<cr>', { nowait = true })

-- telescope find file
api.nvim_set_keymap("n", "ts", "<cmd>Telescope<cr>", { nowait = true })
api.nvim_set_keymap("n", "tf", "<cmd>Telescope find_files<cr>", { nowait = true })
api.nvim_set_keymap("n", "tg", "<cmd>Telescope git_branches<cr>", { nowait = true })
api.nvim_set_keymap("n", "tb", "<cmd>Telescope buffers<cr>", { nowait = true })
api.nvim_set_keymap("n", "ts", "<cmd>Telescope live_grep<cr>", { nowait = true })

-- lazygit
-- api.nvim_set_keymap('n', 'lg', '<cmd>LazyGit<cr>', {nowait = true})

-- rustaceanvim
g.rustaceanvim = {
	tools = {
		Opts = {
			enable_clippy = false,
		},
	},
	FloatWinConfig = {
		auto_focus = true,
	},
	lsp = {
		ClientOpts = {
			status_notify_level = false,
		},
	},
}

-- fold
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
