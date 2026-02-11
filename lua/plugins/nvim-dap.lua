return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("nvim-dap-virtual-text").setup()
		dapui.setup()

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		dap.adapters.lldb = {
			type = "executable",
			command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
			name = "lldb",
		}

		dap.configurations.c = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					local outfile = string.match(vim.fn.expand("%"), "(.+)/[^/]*%.%w+$") .. "/a.out"
					local flags = vim.fn.input("build flags: ", "", "file")
					vim.fn.system("clang -g " .. vim.fn.buffer_name() .. " " .. flags .. " -o " .. outfile)
					return outfile
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}

		dap.adapters.go = function(callback, config)
			local stdout = vim.loop.new_pipe(false)
			local handle
			local pid_or_err
			local port = math.random(38000, 39000)
			local opts = {
				stdio = { nil, stdout },
				args = { "dap", "-l", "127.0.0.1:" .. port },
				detached = true,
			}
			handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
				stdout:close()
				handle:close()
				if code ~= 0 then
					print("dlv exited with code", code)
				end
			end)
			assert(handle, "Error running dlv: " .. tostring(pid_or_err))
			stdout:read_start(function(err, chunk)
				assert(not err, err)
				if chunk then
					vim.schedule(function()
						require("dap.repl").append(chunk)
					end)
				end
			end)
			-- Wait for delve to start
			vim.defer_fn(function()
				callback({
					type = "server",
					host = "127.0.0.1",
					port = port,
					options = { initialize_timeout_sec = 30 },
				})
			end, 100)
		end

		dap.configurations.go = {
			{
				type = "go",
				name = "Debug",
				request = "launch",
				program = "${file}",
				args = function()
					return { vim.fn.input("arguments to program:") }
				end,
			},
		}

		-- Keybindings
		local map = vim.keymap.set
		map("n", "'d", dap.continue, { desc = "DAP Continue" })
		map("n", "'b", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
		map("n", "'cl", dap.clear_breakpoints, { desc = "DAP Clear Breakpoints" })
		map("n", "'t", dap.terminate, { desc = "DAP Terminate" })
		map("n", "'ro", dap.repl.open, { desc = "DAP REPL Open" })
		map("n", "'rc", dap.repl.close, { desc = "DAP REPL Close" })
		map("n", "'ut", dapui.toggle, { desc = "DAP UI Toggle" })
		map("n", "'ue", dapui.eval, { desc = "DAP UI Eval" })
		map("n", "'fe", function()
			dapui.float_element(nil, { width = 200, height = 40, enter = true })
		end, { desc = "DAP UI Float Element" })
	end,
}