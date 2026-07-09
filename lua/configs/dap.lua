local dap = require "dap"
local dapui = require "dapui"

local ok_mason_dap, mason_dap = pcall(require, "mason-nvim-dap")

if ok_mason_dap then
  mason_dap.setup {
    ensure_installed = { "codelldb", "python" },
    automatic_installation = true,
    handlers = {
      function(config)
        require("mason-nvim-dap").default_setup(config)
      end,
    },
  }
end

dapui.setup()

local function input_executable()
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

local codelldb_launch = {
  name = "Launch executable",
  type = "codelldb",
  request = "launch",
  program = input_executable,
  cwd = "${workspaceFolder}",
  stopOnEntry = false,
}

dap.configurations.c = { codelldb_launch }
dap.configurations.cpp = { codelldb_launch }
dap.configurations.cuda = { codelldb_launch }
dap.configurations.rust = { codelldb_launch }

local function python_path()
  local virtual_env = os.getenv "VIRTUAL_ENV"

  if virtual_env then
    return virtual_env .. "/bin/python"
  end

  local python3 = vim.fn.exepath "python3"
  if python3 ~= "" then
    return python3
  end

  return "python"
end

dap.configurations.python = {
  {
    name = "Launch current file",
    type = "python",
    request = "launch",
    program = "${file}",
    pythonPath = python_path,
  },
}

dap.listeners.after.event_initialized.dapui_config = function()
  dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

local function map(key, rhs, desc)
  vim.keymap.set("n", key, rhs, { desc = "DAP: " .. desc })
end

map("<leader>dc", dap.continue, "continue")
map("<leader>dB", dap.toggle_breakpoint, "toggle breakpoint")
map("<leader>dC", dap.clear_breakpoints, "clear breakpoints")
map("<leader>di", dap.step_into, "step into")
map("<leader>do", dap.step_over, "step over")
map("<leader>dO", dap.step_out, "step out")
map("<leader>dr", dap.repl.open, "open repl")
map("<leader>du", dapui.toggle, "toggle ui")
map("<leader>dx", dap.terminate, "terminate")
map("<leader>dl", function()
  dap.set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
end, "set logpoint")
