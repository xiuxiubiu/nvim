local api = vim.api
local g = vim.g
local opt = vim.opt

opt.termguicolors = true -- Enable colors in termimal
opt.hlsearch = true -- Set highlight on search
opt.number = true -- Make line numbers default
opt.tabstop = 4 -- set ts=4
opt.sw = 4 -- set sw=4
opt.mouse = 'a' -- Enable mouse mode
opt.ignorecase = true -- Case insensitive searching unless /C or capital search
opt.signcolumn = 'yes' -- Always show sign column
opt.clipboard = 'unnamedplus' -- AAccess system clipboard
opt.autochdir = true
-- http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
opt.formatoptions = 'r'
opt.autoread = true

-- Check if we need to reload the file when it changed
api.nvim_create_autocmd("BufEnter", { command = [[:checktime]] })

-- debug
api.nvim_set_keymap('n', '\'d', '<cmd> lua require"dap".continue()<cr>', {})
api.nvim_set_keymap('n', '\'b', '<cmd> lua require"dap".toggle_breakpoint()<cr>', {})
api.nvim_set_keymap('n', '\'l', '<cmd> lua require"dap".list_breakpoints()<cr>', {})
api.nvim_set_keymap('n', '\'c', '<cmd> lua require"dap".clear_breakpoints()<cr>', {}) 
api.nvim_set_keymap('n', '\'t', '<cmd> lua require"dap".terminate()<cr>', {})

-- dapui
api.nvim_set_keymap('n', '\'ut', '<cmd> lua require"dapui".toggle()<cr>', {})
api.nvim_set_keymap('n', '\'fe', '<cmd> lua require"dapui".float_element(nil, {width=60, height=20, enter=true})<cr>', {nowait=true})

-- lsp
vim.diagnostic.config({float={border="single"}})
api.nvim_set_keymap('n', '\'g', '<cmd> lua vim.lsp.buf.definition()<cr>', {})
api.nvim_set_keymap('n', '\'r', '<cmd> lua vim.lsp.buf.references({float=true})<cr>', {})
api.nvim_set_keymap('n', '\'f', '<cmd> lua vim.diagnostic.open_float()<cr>', {})
api.nvim_set_keymap('n', '\'el', '<cmd> lua vim.diagnostic.setloclist()<cr>', {})
api.nvim_set_keymap('n', '\'ep', '<cmd> lua vim.diagnostic.goto_prev()<cr><cmd> lua vim.diagnostic.open_float()<cr>', {})
api.nvim_set_keymap('n', '\'en', '<cmd> lua vim.diagnostic.goto_next()<cr><cmd> lua vim.diagnostic.open_float()<cr>', {})
api.nvim_set_keymap('n', '\'h', '<cmd> lua vim.lsp.buf.hover()<cr>', {})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		-- Use a sharp border with `FloatBorder` highlights
		border = "single"
	}
)

-- buffers
api.nvim_set_keymap('n', ']', '<cmd> bn<cr>', {nowait = true})
api.nvim_set_keymap('n', '[', '<cmd> bp<cr>', {nowait = true})
for i = 1, 9, 1 do
	api.nvim_set_keymap('n', i .. '<cr>', '<cmd> BufferLineGoToBuffer '.. i .. '<cr>', {nowait = true})
end

-- nvim-tree
api.nvim_set_keymap('n', '\\', '<cmd> NvimTreeToggle<cr>', {nowait = true})
api.nvim_set_keymap('n', '<C-c>', '<cmd> bd<cr>', {nowait = true})
api.nvim_set_keymap('n', '<C-q>', '<cmd> q<cr>', {nowait = true})


-- toggleterm
api.nvim_set_keymap('n', '<C-\\>', '<cmd> ToggleTerm<cr>', {nowait = true})

-- spectre
api.nvim_set_keymap('n', '<C-s>', '<cmd> lua require"spectre".open_visual({select_word = true})<cr>', {nowait = true})

-- Comment
api.nvim_set_keymap('n', '<C-_>', '<cmd> lua require"Comment.api".toggle_current_linewise()<cr><cmd> normal $<cr>', {nowait = true})
api.nvim_set_keymap('i', '<C-_>', '<cmd> lua require"Comment.api".toggle_current_linewise()<cr><cmd> normal $<cr>', {nowait = true})
api.nvim_set_keymap('x', '<C-_>', '<esc><cmd>lua require"Comment.api".toggle_linewise_op(vim.fn.visualmode())<cr><cmd> normal $<cr>', {nowait = true})
 

