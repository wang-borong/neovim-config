require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Disable mappings which i don't like
nomap("n", "<C-c>")
nomap("n", "<Tab>")
nomap("n", "<S-tab>")


-- Create mappings
-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>p", "<cmd> %y+ <CR>", { desc = "Copy whole file" })
map("n", "<leader>w", "<cmd> w <CR>", { desc = "Save file" })
map("n", "<leader>db", "gg0vG$d", { desc = "Delete all contents from current buffer" })
map("n", "<leader>s", ":Telescope grep_string<CR>", { desc = "Telescope grep_string" })
map("n", "<leader>j", function()
  local cwd = vim.fn.getcwd()
  local fdir = vim.fn.expand("%:p:h")
  if cwd ~= fdir then
    vim.cmd("cd "..fdir)
  else
    -- catch the exception when no previous directory
    vim.cmd("try | cd - | catch | | endtry")
  end
  vim.cmd("pwd")
end, { desc = "Switch dir to file's dir or cwd(where nvim executed)" })
-- telescope
map("n", "<leader>te", ":Telescope <CR>", { desc = "Spawn telescope" })
map("n", "<leader>tl", ":Telescope live_grep<CR>", { desc = "Telescope live_grep" })
-- truezen
map("n", "<leader>ta", ":TZAtaraxis <CR>", { desc = "Enter ataraxis mode of truezen" })
map("n", "<leader>tm", ":TZMinimalist <CR>", { desc = "Enter minimize mode of truezen" })
map("n", "<leader>tf", ":TZFocus <CR>", { desc = "Enter focus mode of truezen" })

-- buffer navigation
map("n", "<A-j>", function()
  require("nvchad.tabufline").next()
end, { desc = "Goto next buffer" })
map("n", "<A-k>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Goto prev buffer" })

map("n", "<leader><space>", function()
  local saved_cursor = vim.api.nvim_win_get_cursor(0)
  local old_query = vim.fn.getreg('/')
  vim.cmd([[silent! %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, saved_cursor)
  vim.fn.setreg('/', old_query)
end, { desc = "Clean extra space" })

-- Visual mode pressing * or # searches for the current selection
-- Super useful! From an idea by Michael Naumann
map("v", "*", function()
  require("helper").visual_selection(false)
  vim.cmd(string.format("/%s", vim.fn.getreg("/")))
end, { desc = "Forward search for the selected text" })
map("v", "#", function()
  require("helper").visual_selection(false)
  vim.cmd(string.format("?%s", vim.fn.getreg("/")))
end, { desc = "Backward search for the selected text" })
-- When you press <leader>r you can search and replace the selected text
map("v", "<leader>r", function()
  require("helper").visual_selection(true)
end, { desc = "Search and replace the selected text" })
