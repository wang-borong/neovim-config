require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Disable unwanted mappings
local disabled_mappings = { "<C-c>", "<Tab>", "<S-tab>" }
for _, key in ipairs(disabled_mappings) do
  nomap("n", key)
end

-- Helper function to create command mappings
local function cmd_map(mode, key, command, desc)
  map(mode, key, "<cmd> " .. command .. " <CR>", { desc = desc })
end

-- Helper function to create telescope mappings
local function telescope_map(key, command, desc)
  cmd_map("n", key, "Telescope " .. command, desc)
end

-- Basic file operations
cmd_map("n", "<leader>p", "%y+", "Copy whole file")
cmd_map("n", "<leader>w", "w", "Save file")
map("n", "<leader>db", "gg0vG$d", { desc = "Delete all contents from current buffer" })

-- Telescope mappings
telescope_map("<leader>s", "grep_string", "Telescope grep_string")
telescope_map("<leader>te", "", "Spawn telescope")
telescope_map("<leader>tl", "live_grep", "Telescope live_grep")

-- Other utility mappings
map("n", "<leader>u", function()
  require("functions").to_utf8()
end, { desc = "Convert file encoding to UTF-8" })
map({ "n", "v" }, "<leader>fm", function()
  require("conform").format {
    async = true,
    lsp_format = "fallback",
  }
end, { desc = "Format file or range" })

-- Buffer navigation
local tabufline = require "nvchad.tabufline"
map("n", "<A-j>", tabufline.next, { desc = "Goto next buffer" })
map("n", "<A-k>", tabufline.prev, { desc = "Goto prev buffer" })

-- Switch directory to file's directory or previous directory
map("n", "<leader>j", function()
  local cwd = vim.fn.getcwd()
  local filename = vim.api.nvim_buf_get_name(0)

  if filename == "" then
    vim.notify("The current buffer has no file directory", vim.log.levels.WARN)
    return
  end

  local file_dir = vim.fs.dirname(filename)

  if cwd ~= file_dir then
    local ok, err = pcall(vim.api.nvim_set_current_dir, file_dir)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
  else
    pcall(vim.cmd, "cd -")
  end
  vim.cmd "pwd"
end, { desc = "Switch dir to file's dir or cwd(where nvim executed)" })

-- Clean trailing whitespace
map("n", "<leader><space>", function()
  local saved_cursor = vim.api.nvim_win_get_cursor(0)
  local old_query = vim.fn.getreg "/"
  vim.cmd [[silent! %s/\s\+$//e]]
  vim.api.nvim_win_set_cursor(0, saved_cursor)
  vim.fn.setreg("/", old_query)
end, { desc = "Clean extra space" })

-- Visual mode search mappings
local helper = require "helper"
local function visual_search(direction)
  return function()
    helper.visual_selection(false)
    local pattern = vim.fn.getreg "/"
    vim.fn.search(pattern, direction == "?" and "bW" or "W")
  end
end

map("v", "*", visual_search "/", { desc = "Forward search for the selected text" })
map("v", "#", visual_search "?", { desc = "Backward search for the selected text" })
map("v", "<leader>r", function()
  helper.visual_selection(true)
end, { desc = "Search and replace the selected text" })
