local M = {}

function M.setup()
  local cortex_debug = require "dap-cortex-debug"

  cortex_debug.setup {
    dap_vscode_filetypes = { "c", "cpp", "cuda" },
  }

  local function input_elf()
    return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "/build/", "file")
  end

  local function input_openocd_target()
    return vim.fn.input("OpenOCD target config: ", "target/stm32f4x.cfg", "file")
  end

  local cortex_openocd = cortex_debug.openocd_config {
    name = "STM32 ST-Link cortex-debug launch",
    cwd = "${workspaceFolder}",
    executable = input_elf,
    configFiles = function()
      return { "interface/stlink.cfg", input_openocd_target() }
    end,
    gdbTarget = "localhost:3333",
    rttConfig = cortex_debug.rtt_config(0),
    showDevDebugOutput = false,
  }

  local dap = require "dap"
  dap.configurations.c = dap.configurations.c or {}
  dap.configurations.cpp = dap.configurations.cpp or {}
  dap.configurations.cuda = dap.configurations.cuda or {}

  table.insert(dap.configurations.c, cortex_openocd)
  table.insert(dap.configurations.cpp, vim.deepcopy(cortex_openocd))
  table.insert(dap.configurations.cuda, vim.deepcopy(cortex_openocd))
end

return M
