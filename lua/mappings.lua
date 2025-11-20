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

-- TrueZen mappings
local truezen_commands = {
  ta = "TZAtaraxis",
  tm = "TZMinimalist",
  tf = "TZFocus",
}
for key, command in pairs(truezen_commands) do
  cmd_map("n", "<leader>" .. key, command, "Enter " .. command:lower() .. " mode of truezen")
end

-- Other utility mappings
cmd_map("n", "<leader>u", "lua ToUTF8()", "Convert file encoding to utf-8")

-- Buffer navigation
local tabufline = require("nvchad.tabufline")
map("n", "<A-j>", tabufline.next, { desc = "Goto next buffer" })
map("n", "<A-k>", tabufline.prev, { desc = "Goto prev buffer" })

-- Switch directory to file's directory or previous directory
map("n", "<leader>j", function()
  local cwd = vim.fn.getcwd()
  local file_dir = vim.fn.expand("%:p:h")
  
  if cwd ~= file_dir then
    vim.cmd("cd " .. file_dir)
  else
    vim.cmd("try | cd - | catch | | endtry")
  end
  vim.cmd("pwd")
end, { desc = "Switch dir to file's dir or cwd(where nvim executed)" })

-- Clean trailing whitespace
map("n", "<leader><space>", function()
  local saved_cursor = vim.api.nvim_win_get_cursor(0)
  local old_query = vim.fn.getreg('/')
  vim.cmd([[silent! %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, saved_cursor)
  vim.fn.setreg('/', old_query)
end, { desc = "Clean extra space" })

-- Visual mode search mappings
local helper = require("helper")
local function visual_search(direction)
  return function()
    helper.visual_selection(false)
    local pattern = vim.fn.getreg("/")
    vim.cmd(string.format("%s%s", direction, pattern))
  end
end

map("v", "*", visual_search("/"), { desc = "Forward search for the selected text" })
map("v", "#", visual_search("?"), { desc = "Backward search for the selected text" })
map("v", "<leader>r", function()
  helper.visual_selection(true)
end, { desc = "Search and replace the selected text" })
