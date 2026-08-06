-- Jupyter / Notebook workflow
--
-- The notebook is edited as a text representation through jupytext.nvim,
-- executed by molten-nvim, and receives Python LSP features from quarto.nvim
-- and otter.nvim.
--
-- Kernels come from Jupyter's user kernelspecs. <localleader>mk registers the
-- current project's .venv as a kernel and attaches to it; <localleader>mi
-- picks from the kernels already installed.

-- Walk up from the current file to the nearest .venv, stopping at the repo
-- boundary so a venv outside the project is never picked up. Mirrors the
-- pyright resolution in nvim-lspconfig.lua so the notebook and the LSP agree
-- on the interpreter.
local function find_project_venv()
	local dir = vim.fn.expand("%:p:h")
	if dir == "" then
		dir = vim.fn.getcwd()
	end
	while dir do
		local python = dir .. "/.venv/bin/python"
		if vim.fn.executable(python) == 1 then
			return python, dir
		end
		if vim.uv.fs_stat(dir .. "/.git") then
			break
		end
		local parent = vim.fs.dirname(dir)
		if parent == dir then
			break
		end
		dir = parent
	end
end

local function molten_init_project_kernel()
	local python, root = find_project_venv()
	if not python then
		vim.notify("No .venv found for this buffer; use <localleader>mi to pick a kernel", vim.log.levels.WARN)
		return
	end

	vim.fn.system({ python, "-c", "import ipykernel" })
	if vim.v.shell_error ~= 0 then
		vim.notify("ipykernel is not installed in " .. root .. "/.venv", vim.log.levels.ERROR)
		return
	end

	-- Registering is idempotent, so this doubles as a repair when the kernel
	-- spec points at a venv that was since rebuilt.
	local name = vim.fn.fnamemodify(root, ":t")
	local out = vim.fn.system({
		python,
		"-m",
		"ipykernel",
		"install",
		"--user",
		"--name",
		name,
		"--display-name",
		name,
	})
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to register kernel:\n" .. out, vim.log.levels.ERROR)
		return
	end

	vim.cmd("MoltenInit " .. name)
end

return {
	{
		"benlubas/molten-nvim",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"3rd/image.nvim",
		},
		init = function()
			-- iTerm2 does not expose Kitty's graphics protocol, so images go
			-- through image.nvim's ueberzugpp overlay instead.
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_open_cmd = "open"
			vim.g.molten_auto_open_output = false
			vim.g.molten_auto_open_html_in_browser = false
			vim.g.molten_wrap_output = true
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_lines_off_by_1 = true
			-- "init" lets a run command on a kernel-less buffer offer a kernel
			-- picker and then run the cell, instead of throwing. Nothing
			-- prompts on open, because no autocmd runs Molten commands for a
			-- buffer that has no kernel yet.
			vim.g.molten_auto_init_behavior = "init"
		end,
		config = function()
			local map = vim.keymap.set

			map("n", "<localleader>mi", "<cmd>MoltenInit<cr>", { desc = "Jupyter: initialize kernel" })
			map("n", "<localleader>mk", molten_init_project_kernel, { desc = "Jupyter: init project .venv kernel" })
			map("n", "<localleader>mr", "<cmd>MoltenReevaluateCell<cr>", { desc = "Jupyter: re-run cell" })
			map("n", "<localleader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", { desc = "Jupyter: open output" })
			map("n", "<localleader>mh", "<cmd>MoltenHideOutput<cr>", { desc = "Jupyter: hide output" })
			map("n", "<localleader>mx", "<cmd>MoltenOpenInBrowser<cr>", { desc = "Jupyter: open HTML output" })
			map("n", "<localleader>mR", "<cmd>MoltenRestart<cr>", { desc = "Jupyter: restart kernel" })
			map("n", "<localleader>mK", "<cmd>MoltenInterrupt<cr>", { desc = "Jupyter: interrupt kernel" })
			map("n", "<localleader>mI", "<cmd>MoltenImportOutput<cr>", { desc = "Jupyter: import outputs" })
			map("n", "<localleader>mE", "<cmd>MoltenExportOutput!<cr>", { desc = "Jupyter: export outputs" })

			-- Both hooks below must check that *this buffer* has a kernel.
			-- status.initialized() only reports the global plugin flag, so it
			-- stays true for kernel-less buffers and the command would error.
			local function buffer_has_kernel()
				local ok, status = pcall(require, "molten.status")
				return ok and status.kernels() ~= ""
			end

			-- Keep cell outputs in the .ipynb across the edit/save cycle.
			-- Importing on kernel start rather than on BufEnter means opening a
			-- notebook never triggers kernel selection on its own.
			vim.api.nvim_create_autocmd("User", {
				pattern = "MoltenKernelReady",
				callback = function()
					if vim.fn.expand("%:e") == "ipynb" then
						pcall(vim.cmd, "MoltenImportOutput")
					end
				end,
			})
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.ipynb",
				callback = function()
					if buffer_has_kernel() then
						pcall(vim.cmd, "MoltenExportOutput!")
					end
				end,
			})
		end,
	},

	{
		"3rd/image.nvim",
		build = false,
		opts = {
			backend = "ueberzug",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "quarto" },
				},
			},
		},
	},

	{
		"GCBallesteros/jupytext.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("jupytext").setup({
				style = "markdown",
				output_extension = "md",
				force_ft = "markdown",
			})
		end,
	},

	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto", "markdown" },
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local quarto = require("quarto")
			quarto.setup({
				lspFeatures = {
					languages = { "python", "r", "julia" },
					chunks = "all",
					diagnostics = { enabled = true, triggers = { "BufWritePost" } },
					completion = { enabled = true },
				},
				codeRunner = {
					enabled = true,
					default_method = "molten",
				},
			})

			-- quarto.setup only registers commands. Otter has to be attached per
			-- buffer, otherwise code cells get no completion, hover or
			-- diagnostics.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "quarto", "markdown" },
				callback = function()
					pcall(quarto.activate)
				end,
			})

			local runner = require("quarto.runner")
			vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "Jupyter: run cell" })
			vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "Jupyter: run above" })
			vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "Jupyter: run all" })
			vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "Jupyter: run line" })
			vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "Jupyter: run selection" })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "master",
	},
}
