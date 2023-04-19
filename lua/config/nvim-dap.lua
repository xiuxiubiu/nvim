local dap = require 'dap'

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
            local outfile =
                string.match(vim.fn.expand('%'), '(.+)/[^/]*%.%w+$') .. '/a.out'
            local flags = vim.fn.input('build flags: ', '', 'file')
            vim.fn.system('cc -g ' .. vim.fn.buffer_name() .. ' ' .. flags ..
                              ' -o ' .. outfile)
            return outfile
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {}

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
    }
}

-- rust
-- dap.configurations.rust = {
-- 	{
--     	name = 'Launch',
--     	type = 'lldb',
--     	request = 'launch',
--     	program = function()
-- 			local findFile = 'Cargo.toml'
-- 			vim.fn.chdir(string.match(vim.fn.expand('%'), '(.+)/[^/]*%.%w+$'))
-- 			while (true) do
-- 				local currentPath = vim.fn.getcwd()
-- 				if (currentPath == '/') then
-- 					return vim.fn.input('Path to executable: ', '/', 'file')
-- 				end
-- 				if (findFile == vim.fn.findfile(findFile)) then
-- 					vim.fn.system('cargo build')
-- 					return vim.fn.input('executable: ', currentPath .. '/target/debug/', 'file')
-- 				end
-- 				vim.fn.chdir('..')
-- 			end
--     	end,
--     	cwd = '${workspaceFolder}',
--     	stopOnEntry = false,
--     	args = {},
--
--     	-- 💀
--     	-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
--     	--
--     	--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
--     	--
--     	-- Otherwise you might get the following error:
--     	--
--     	--    Error on launch: Failed to attach to the target process
--     	--
--     	-- But you should be aware of the implications:
--     	-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
--     	-- runInTerminal = false,
--
--     	-- 💀
--     	-- If you use `runInTerminal = true` and resize the terminal window,
--     	-- lldb-vscode will receive a `SIGWINCH` signal which can cause problems
--     	-- To avoid that uncomment the following option
--     	-- See https://github.com/mfussenegger/nvim-dap/issues/236#issuecomment-1066306073
--     	-- postRunCommands = {'process handle -p true -s false -n false SIGWINCH'}
-- 	},
-- }

dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = math.random(38000, 39000)
    local opts = {
        stdio = {nil, stdout},
        args = {"dap", "-l", "127.0.0.1:" .. port},
        detached = true
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
        stdout:close()
        handle:close()
        if code ~= 0 then print('dlv exited with code', code) end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            vim.schedule(function() require('dap.repl').append(chunk) end)
        end
    end)
    -- Wait for delve to start
    vim.defer_fn(function()
        callback({
            type = "server",
            host = "127.0.0.1",
            port = port,
            options = {initialize_timeout_sec = 30}
        })
    end, 100)
end

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
        args = function() return {vim.fn.input('arguments to program:')} end
    }
}
