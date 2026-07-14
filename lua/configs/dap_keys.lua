return {
  {
    "<leader>dc",
    function()
      require("dap").continue()
    end,
    desc = "DAP: continue",
  },
  {
    "<leader>dB",
    function()
      require("dap").toggle_breakpoint()
    end,
    desc = "DAP: toggle breakpoint",
  },
  {
    "<leader>dC",
    function()
      require("dap").clear_breakpoints()
    end,
    desc = "DAP: clear breakpoints",
  },
  {
    "<leader>di",
    function()
      require("dap").step_into()
    end,
    desc = "DAP: step into",
  },
  {
    "<leader>do",
    function()
      require("dap").step_over()
    end,
    desc = "DAP: step over",
  },
  {
    "<leader>dO",
    function()
      require("dap").step_out()
    end,
    desc = "DAP: step out",
  },
  {
    "<leader>dr",
    function()
      require("dap").repl.open()
    end,
    desc = "DAP: open REPL",
  },
  {
    "<leader>du",
    function()
      require("dapui").toggle()
    end,
    desc = "DAP: toggle UI",
  },
  {
    "<leader>dx",
    function()
      require("dap").terminate()
    end,
    desc = "DAP: terminate",
  },
  {
    "<leader>dl",
    function()
      require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
    end,
    desc = "DAP: set logpoint",
  },
}
