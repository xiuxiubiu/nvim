local opt = vim.opt

-- Use the dedicated Jupyter environment for Neovim's Python remote-plugin
-- host. Project virtual environments remain available to Pyright and kernels.
local jupyter_venv = vim.fn.stdpath("data") .. "/jupyter-venv"
vim.g.python3_host_prog = jupyter_venv .. "/bin/python"

-- jupytext.nvim shells out to a bare `jupytext`, so the binary has to be on
-- Neovim's PATH. Prepending here instead of in the login shell keeps the
-- notebook tooling scoped to Neovim.
vim.env.PATH = jupyter_venv .. "/bin:" .. vim.env.PATH

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
opt.autoread = true

-- Check if we need to reload the file when it changed
local file_reload_group = vim.api.nvim_create_augroup("ExternalFileReload", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = file_reload_group,
	callback = function()
		vim.schedule(function()
			vim.cmd("checktime")
		end)
	end,
})

if type(vim.g.external_file_check_timer) == "number" then
	vim.fn.timer_stop(vim.g.external_file_check_timer)
end

local file_check_timer = vim.fn.timer_start(3000, function()
	vim.cmd("checktime")
end, { ["repeat"] = -1 })
vim.g.external_file_check_timer = file_check_timer

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = file_reload_group,
	callback = function()
		vim.fn.timer_stop(file_check_timer)
		if vim.g.external_file_check_timer == file_check_timer then
			vim.g.external_file_check_timer = nil
		end
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
		-- Built-in indent scripts set autoindent; defer the override so it
		-- wins regardless of autocmd execution order.
		vim.schedule(function()
			vim.opt_local.autoindent = false
		end)
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

-- Neovim 0.11 removed the vim.health.report_* aliases in favour of
-- vim.health.start/ok/info/warn/error. Plugins still on the old names (e.g.
-- jupytext.nvim) make :checkhealth abort with "attempt to call field
-- 'report_start'" instead of running their check. Map the old names back.
for old, new in pairs({
	report_start = "start",
	report_ok = "ok",
	report_info = "info",
	report_warn = "warn",
	report_error = "error",
}) do
	if not vim.health[old] then
		vim.health[old] = vim.health[new]
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
-- References: jump straight to the only hit, otherwise pick from a floating
-- picker. Uses on_list so a single LSP request drives both paths.
local function jump_to_item(item)
	-- Record the current spot in the jumplist before moving.
	vim.cmd("normal! m'")
	local bufnr = item.bufnr or vim.fn.bufadd(item.filename)
	vim.bo[bufnr].buflisted = true
	vim.api.nvim_win_set_buf(0, bufnr)
	vim.api.nvim_win_set_cursor(0, { item.lnum, math.max((item.col or 1) - 1, 0) })
	vim.cmd("normal! zz")
end

local function pick_reference(items)
	local ok, pickers = pcall(require, "telescope.pickers")
	if not ok then
		vim.fn.setqflist({}, " ", { title = "LSP References", items = items })
		vim.cmd("copen")
		return
	end

	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local make_entry = require("telescope.make_entry")

	-- flex puts the preview beside the list when there is room, so the preview
	-- gets the full picker height instead of a slice of it, and stacks it above
	-- the list when there is not. The switch compares vim.o.columns against
	-- flip_columns; 130 is where a 0.6 preview share still leaves ~70 cells of
	-- code and ~47 for the results column.
	--
	-- width/height are repeated in both sub-tables on purpose. flex merges
	-- Telescope's own horizontal/vertical defaults (0.8 x 0.9) into whichever
	-- sub-table it delegates to, and that merged table outranks anything set at
	-- the top level of layout_config. Hoisting these silently resizes the picker.
	local opts = {
		layout_strategy = "flex",
		layout_config = {
			flip_columns = 130,
			horizontal = {
				width = 0.9,
				height = 0.85,
				prompt_position = "top",
				preview_width = 0.6,
				preview_cutoff = 1,
			},
			vertical = {
				width = 0.9,
				height = 0.9,
				prompt_position = "top",
				preview_height = 0.5,
				preview_cutoff = 1,
			},
		},
		-- References come back ordered by file and line rather than ranked, so
		-- they have to read top-down instead of growing upward from the prompt.
		sorting_strategy = "ascending",
		-- gen_from_quickfix pins its path column to 30 cells whenever the inline
		-- snippet is shown, and that column truncates from the right, cutting off
		-- the filename and :line:col. Dropping the snippet leaves a single
		-- full-width column, so path_display's tail-preserving truncation governs
		-- instead. The snippet text stays in each entry's ordinal, so typing code
		-- text still filters the list.
		show_line = false,
		-- truncate's budget is the results width less the caret and 2 cells; it
		-- does not know gen_from_quickfix still has to append ":lnum:col", so a
		-- bare { "truncate" } overflows the window and the line/col get clipped.
		-- The number reserves that many extra cells: 10 covers ":12345:123".
		path_display = { truncate = 10 },
	}

	pickers
		.new(opts, {
			prompt_title = "LSP References",
			finder = finders.new_table({
				results = items,
				entry_maker = make_entry.gen_from_quickfix(opts),
			}),
			previewer = conf.qflist_previewer(opts),
			sorter = conf.generic_sorter(opts),
			push_cursor_on_edit = true,
			push_tagstack_on_edit = true,
		})
		:find()
end

map("n", "'rf", function()
	local cur_file = vim.api.nvim_buf_get_name(0)
	local cur_lnum = vim.api.nvim_win_get_cursor(0)[1]

	vim.lsp.buf.references({ includeDeclaration = true }, {
		on_list = function(result)
			-- Drop the symbol under the cursor so a definition with a single
			-- usage still counts as one reference.
			local items = vim.tbl_filter(function(item)
				return not (item.filename == cur_file and item.lnum == cur_lnum)
			end, result.items or {})

			if #items == 0 then
				vim.notify("No references found", vim.log.levels.INFO)
			elseif #items == 1 then
				jump_to_item(items[1])
			else
				pick_reference(items)
			end
		end,
	})
end, { desc = "LSP References" })
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
