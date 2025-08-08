local vim = vim
local dap = require('dap')

-- This is needed so dap doesnt overwrite every fucking buffer you have open as soon as you step or smth
vim.o.switchbuf = "useopen,uselast"

dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

dap.configurations.c = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		console = 'internalConsole',
		stopAtBegginningOfMainSubprogram = false,
	},
	{
		name = "Select and attach process",
		type = "gdb",
		request = "attach",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		pid = function()
			local name = vim.fn.input('Executable name (filter): ')
			return require("dap.utils").pick_process({filder = name})
		end,
		cwd = '${workspaceFolder}'
	},
	{
		name = "Attach to gdbserver :1234",
		type = 'gdb',
		request = 'attach',
		target = 'localhost:1234',
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}'
	}
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c
