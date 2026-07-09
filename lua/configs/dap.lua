local dap = require "dap"
local dapui = require "dapui"

local ok_dap_virtual_text, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
local ok_mason_dap, mason_dap = pcall(require, "mason-nvim-dap")
local ok_dap_go, dap_go = pcall(require, "dap-go")

local function first_executable(candidates)
  for _, command in ipairs(candidates) do
    local path = vim.fn.exepath(command)

    if path ~= "" then
      return path
    end
  end

  return nil
end

if ok_mason_dap then
  mason_dap.setup {
    ensure_installed = { "codelldb", "delve", "javadbg", "javatest", "kotlin", "python" },
    automatic_installation = true,
    handlers = {
      function(config)
        require("mason-nvim-dap").default_setup(config)
      end,
    },
  }
end

if ok_dap_virtual_text then
  dap_virtual_text.setup {
    commented = true,
  }
end

if ok_dap_go then
  dap_go.setup()
end

dapui.setup()

local function input_executable()
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

local function input_elf()
  return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "/build/", "file")
end

local function split_args()
  return vim.split(vim.fn.input "Args: ", " +", { trimempty = true })
end

local function run_session_commands(session, commands)
  local index = 1

  local function next_command()
    local command = commands[index]
    if not command then
      return
    end

    session:evaluate({ expression = command, context = "repl" }, function()
      index = index + 1
      next_command()
    end)
  end

  next_command()
end

local codelldb_launch = {
  {
    name = "Launch executable",
    type = "codelldb",
    request = "launch",
    program = input_executable,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Launch executable with args",
    type = "codelldb",
    request = "launch",
    program = input_executable,
    args = split_args,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Attach process",
    type = "codelldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}

local gdb_command = first_executable { "arm-none-eabi-gdb", "gdb-multiarch", "gdb" }

if gdb_command then
  dap.adapters.arm_gdb = {
    type = "executable",
    command = gdb_command,
    args = { "-i", "dap" },
  }
end

local stm32_openocd_attach = {
  {
    name = "STM32 ST-Link OpenOCD attach",
    type = "arm_gdb",
    request = "attach",
    program = input_elf,
    cwd = "${workspaceFolder}",
    target = "localhost:3333",
    stm32_init_commands = { "monitor reset halt" },
  },
  {
    name = "STM32 ST-Link OpenOCD attach + load",
    type = "arm_gdb",
    request = "attach",
    program = input_elf,
    cwd = "${workspaceFolder}",
    target = "localhost:3333",
    stm32_init_commands = { "monitor reset halt", "load", "monitor reset halt" },
  },
}

dap.configurations.c = vim.list_extend(vim.deepcopy(codelldb_launch), vim.deepcopy(stm32_openocd_attach))
dap.configurations.cpp = vim.list_extend(vim.deepcopy(codelldb_launch), vim.deepcopy(stm32_openocd_attach))
dap.configurations.cuda = vim.deepcopy(dap.configurations.cpp)
dap.configurations.rust = vim.deepcopy(codelldb_launch)

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

dap.adapters.kotlin = function(callback)
  local kotlin_debug_adapter = vim.fn.exepath "kotlin-debug-adapter"

  if kotlin_debug_adapter == "" then
    vim.notify("kotlin-debug-adapter is not installed", vim.log.levels.WARN)
    return
  end

  callback {
    type = "executable",
    command = kotlin_debug_adapter,
    options = {
      auto_continue_if_many_stopped = false,
    },
  }
end

dap.configurations.kotlin = {
  {
    name = "Kotlin launch",
    type = "kotlin",
    request = "launch",
    projectRoot = "${workspaceFolder}",
    mainClass = function()
      return vim.fn.input "Main class: "
    end,
  },
  {
    name = "Kotlin attach remote JVM",
    type = "kotlin",
    request = "attach",
    hostName = "127.0.0.1",
    port = 5005,
    projectRoot = "${workspaceFolder}",
  },
}

dap.listeners.after.event_initialized.dapui_config = function()
  dapui.open()
end

dap.listeners.after.event_stopped.stm32_openocd = function(session)
  if not session.config.stm32_init_commands or session.stm32_init_done then
    return
  end

  session.stm32_init_done = true
  run_session_commands(session, session.config.stm32_init_commands)
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

vim.api.nvim_create_user_command("STM32OpenOCD", function(opts)
  if vim.fn.exepath "openocd" == "" then
    vim.notify("openocd is not installed or not in PATH", vim.log.levels.ERROR)
    return
  end

  local target_config = opts.args

  if target_config == "" then
    target_config = vim.fn.input("OpenOCD target config: ", "target/stm32f4x.cfg", "file")
  end

  local command = {
    "openocd",
    "-f",
    "interface/stlink.cfg",
    "-f",
    target_config,
  }

  vim.cmd "botright 15split"
  vim.cmd("terminal " .. table.concat(vim.tbl_map(vim.fn.shellescape, command), " "))
end, {
  complete = "file",
  nargs = "?",
})
