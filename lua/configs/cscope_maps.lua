require("cscope_maps").setup({
  -- Maps related defaults
  disable_maps = false,
  skip_input_prompt = false,
  prefix = "<leader>c",

  -- Cscope related defaults
  cscope = {
    db_file = "./cscope.out",
    exec = "cscope", -- "cscope" or "gtags-cscope"
    picker = "quickfix", -- "telescope", "fzf-lua" or "quickfix"
    qf_window_size = 5,
    qf_window_pos = "bottom", -- "bottom", "right", "left" or "top"
    skip_picker_for_single_result = false,
    db_build_cmd = { args = { "-bqkv" } },
    statusline_indicator = nil,
    project_rooter = {
      enable = false,
      change_cwd = false,
    },
  },
})
