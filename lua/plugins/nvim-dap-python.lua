return {
	"mfussenegger/nvim-dap-python",
	dependencies = { "mfussenegger/nvim-dap", "neovim/nvim-lspconfig" },
	config = function()
		local util = require("lspconfig.util")
		local root_files = {
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			"pyrightconfig.json",
			".git",
		}

		-- 适配器统一用 mason 的 debugpy,与被调试项目的解释器解耦
		local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

		require("dap-python").setup(mason_debugpy)

		-- 被调试进程的解释器:优先项目根的 .venv(uv sync 的产物),
		-- 其次已激活的虚拟环境,最后回退 mason debugpy 自带的 python
		require("dap-python").resolve_python = function()
			local root = util.root_pattern(unpack(root_files))(vim.fn.expand("%:p:h"))
			if root then
				local venv = root .. "/.venv/bin/python"
				if vim.fn.executable(venv) == 1 then
					return venv
				end
			end
			if vim.env.VIRTUAL_ENV then
				local venv = vim.env.VIRTUAL_ENV .. "/bin/python"
				if vim.fn.executable(venv) == 1 then
					return venv
				end
			end
			return mason_debugpy
		end

		require("dap-python").test_runner = "pytest"
	end,
}
