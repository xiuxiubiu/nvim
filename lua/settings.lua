local api = vim.api
local g = vim.g
local opt = vim.opt
local fn = vim.fn
local util = vim.util

-- breakpoint
fn.sign_define('DapBreakpoint', {text='●', texthl='', linehl='', numhl=''})

opt.termguicolors = true -- Enable colors in termimal
opt.hlsearch = true -- Set highlight on search
opt.number = true -- Make line numbers default
opt.tabstop = 4 -- set ts=4
opt.sw = 4 -- set sw=4
opt.mouse = '' -- Enable mouse mode
opt.ignorecase = true -- Case insensitive searching unless /C or capital search
opt.signcolumn = 'yes' -- Always show sign column
opt.clipboard = 'unnamedplus' -- AAccess system clipboard opt.autochdir = true -- http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
opt.formatoptions = 'r'

-- Check if we need to reload the file when it changed
api.nvim_create_autocmd("BufEnter", { command = [[:checktime]] })

-- autoformat
api.nvim_create_autocmd("BufWritePost", { command = [[:FormatWrite]], pattern = {'*.go', '*.rs'} })

-- change english
api.nvim_create_autocmd("InsertLeave", { 
	command = [[
		:lua vim.fn.system('/usr/local/bin/im-select com.apple.keylayout.ABC')
	]]
})

-- debug
api.nvim_set_keymap('n', '\'d', '<cmd> lua require"dap".continue()<cr>', {})
api.nvim_set_keymap('n', '\'b', '<cmd> lua require"dap".toggle_breakpoint()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'cl', '<cmd> lua require"dap".clear_breakpoints()<cr>', {nowait = true}) 
api.nvim_set_keymap('n', '\'t', '<cmd> lua require"dap".terminate()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'ro', '<cmd> lua require"dap".repl.open()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'rc', '<cmd> lua require"dap".repl.close()<cr>', {nowait = true})

-- dapui
api.nvim_set_keymap('n', '\'ut', '<cmd> lua require"dapui".toggle()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'fe', '<cmd> lua require"dapui".float_element(nil, {width=200, height=40, enter=true})<cr>', {nowait=true})
api.nvim_set_keymap('n', '\'ue', '<cmd> lua require"dapui".eval()<cr>', {nowait=true})

-- lsp
vim.diagnostic.config({float={border="single"}})
api.nvim_set_keymap('n', '\'rn', '<cmd> lua vim.lsp.buf.rename()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'ca', '<cmd> lua vim.lsp.buf.code_action()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'g', '<cmd> lua vim.lsp.buf.definition()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'rf', '<cmd> lua vim.lsp.buf.references()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'ei', '<cmd> lua vim.diagnostic.open_float()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'el', '<cmd> lua vim.diagnostic.setloclist()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'ep', '<cmd> lua vim.diagnostic.goto_prev()<cr><cmd> lua vim.diagnostic.open_float()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'en', '<cmd> lua vim.diagnostic.goto_next()<cr><cmd> lua vim.diagnostic.open_float()<cr>', {nowait = true})
api.nvim_set_keymap('n', '\'h', '<cmd> lua vim.lsp.buf.hover()<cr>', {nowait = true})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		-- Use a sharp border with `FloatBorder` highlights
		border = "single"
	}
)
local function hover_wrap(_, method, result)
    util.focusable_float(method, function()
        if not (result and result.contents) then
            -- return { 'No information available' }
            return
        end
        local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
        markdown_lines = util.trim_empty_lines(markdown_lines)
        if vim.tbl_isempty(markdown_lines) then
            -- return { 'No information available' }
            return
        end
        local bufnr, winnr = util.fancy_floating_markdown(markdown_lines)
        util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, winnr)
        local hover_len = #vim.api.nvim_buf_get_lines(bufnr,0,-1,false)[1]
        local win_width = vim.api.nvim_win_get_width(0)
        if hover_len > win_width then
            vim.api.nvim_win_set_width(winnr,math.min(hover_len,win_width))
            vim.api.nvim_win_set_height(winnr,math.ceil(hover_len/win_width))
            vim.wo[winnr].wrap = true
        end
        return bufnr, winnr
    end)
end

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
api.nvim_set_keymap('n', '<C-_>', '<cmd> lua require"Comment.api".toggle.linewise.current()<cr><cmd> normal $<cr>', {nowait = true})
api.nvim_set_keymap('i', '<C-_>', '<cmd> lua require"Comment.api".toggle.linewise.current()<cr><cmd> normal $<cr>', {nowait = true})
api.nvim_set_keymap('x', '<C-_>', '<esc><cmd>lua require"Comment.api".toggle.linewise(vim.fn.visualmode())<cr><cmd> normal $<cr>', {nowait = true})

-- {}
api.nvim_set_keymap('i', '{<cr>', '{<cr>}<esc>O', {nowait = true})

-- git
api.nvim_set_keymap('n', 'g]', '<cmd>Gitsigns next_hunk<cr>', {nowait = true})
api.nvim_set_keymap('n', 'g[', '<cmd>Gitsigns prev_hunk<cr>', {nowait = true})
api.nvim_set_keymap('n', 'gd', '<cmd>Gitsigns diffthis<cr>', {nowait = true})
api.nvim_set_keymap('n', 'gi', '<cmd>lua require"gitsigns".blame_line({full = true})<cr>', {nowait = true})
