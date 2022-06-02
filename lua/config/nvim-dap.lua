vim.fn.sign_define('DapBreakpoint', {text='●', texthl='', linehl='', numhl=''})

local dap = require'dap'
dap.adapters.python = {
	type = 'executable';
	command = os.getenv('HOME') .. '/.virtualenvs/debugpy/bin/python';
	args = { '-m', "debugpy.adapter" }
}
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python3'
      end
    end;
  },
}


dap.adapters.lldb = {
	type = 'executable',
	command = '/usr/local/opt/llvm/bin/lldb-vscode',
	name = 'lldb'
}

dap.configurations.c = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
		local outfile = './a.out'
		vim.fn.system('cc -g ' .. vim.fn.buffer_name() .. ' -o ' .. outfile)
      	return outfile
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,

    -- 💀
    -- If you use `runInTerminal = true` and resize the terminal window,
    -- lldb-vscode will receive a `SIGWINCH` signal which can cause problems
    -- To avoid that uncomment the following option
    -- See https://github.com/mfussenegger/nvim-dap/issues/236#issuecomment-1066306073
    -- postRunCommands = {'process handle -p true -s false -n false SIGWINCH'}
  },
}

-- dap.adapters.go = {
-- 	type = 'executable',
-- 	command = 'node',
-- 	args = {'/Users/xudong/Documents/github/vscode-go/dist/debugAdapter.js'},
-- 	options = {
-- 		initialize_timeout_sec = 30
-- 	}
-- }
-- 
-- dap.configurations.go = {
-- 	{
-- 		type = 'go',
-- 		mode = 'debug',
-- 		name = 'Debug',
-- 		request = 'launch',
-- 		showLog = true,
-- 		program = "${file}",
-- 		dlvToolPath = vim.fn.exepath(vim.fn.getenv('GOPATH') .. '/bin/dlv'), -- Adjust to where delve is installed
-- 		args = function()
-- 			return { vim.fn.input('arguments to program:') }
-- 		end
-- 	}
-- }

dap.adapters.go = function(callback, config)
	local stdout = vim.loop.new_pipe(false)
	local handle
	local pid_or_err
	local port = 38697
	local opts = {
		stdio = {nil, stdout},
		args = {"dap", "-l", "127.0.0.1:" .. port},
		detached = true
	}
	handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
		stdout:close()
		handle:close()
		if code ~= 0 then
			print('dlv exited with code', code)
		end
	end)
	assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
	stdout:read_start(function(err, chunk)
		assert(not err, err)
		if chunk then
			vim.schedule(function()
				require('dap.repl').append(chunk)
			end)
		end
	end)
	-- Wait for delve to start
	vim.defer_fn(
		function()
			callback({
				type = "server", 
				host = "127.0.0.1", 
				port = port,
				options = {
					initialize_timeout_sec = 30
				}
			})
		end,
		100)
end
 -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
    args = function()
  	return { vim.fn.input('arguments to program:') }
    end
  },
  {
    type = "go",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  -- works with go.mod packages and sub packages 
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  } 
}
