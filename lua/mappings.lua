require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Disable mappings which i don't like
nomap("i", "<C-b>")
nomap("i", "<C-e>")
nomap("i", "<C-h>")
nomap("i", "<C-j>")
nomap("i", "<C-k>")
nomap("i", "<C-l>")
nomap("n", "<C-s>")
nomap("n", "<C-c>")
nomap("n", "<Tab>")
nomap("n", "<S-tab>")


-- Create mappings
-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>p", "<cmd> %y+ <CR>", { desc = "Copy whole file" })
map("n", "<leader>w", "<cmd> w <CR>", { desc = "Save file" })
map("n", "<leader>db", "gg0vG$d", { desc = "Delete all contents from current buffer" })
map("n", "<leader>s", ":Telescope grep_string<CR>", { desc = "Telescope grep_string" })
map("n", "<leader>j", ":cd %:p:h<CR>:pwd<CR>", { desc = "Enter into the directory of the current file" })
map("n", "<leader>k", ":cd -<CR>", { desc = "Return to last directory" })
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

map("n", "<leader>ic", function()
  local ft = vim.bo.filetype
  local comments
  local col = 3
  if ft == 'c' or ft == 'go' or
    ft == 'java' or ft == 'verilog' or
    ft == 'cpp' then
    comments = { "/*", " * ", " */" }
  elseif ft == 'rust' then
    comments = { "//", "// ", "//" }
  elseif ft == 'python' then
    comments = {'"""', '', '"""'}
    col = 1
  elseif ft == 'sh' then
    comments = { "#", "# ", "#" }
    col = 2
  elseif ft == 'lua' then
    comments = { "-- [[", "-- ", "-- ]]" }
  elseif ft == 'tex' or ft == 'plaintex' then
    comments = { "%", "% ", "%" }
    col = 2
  elseif ft == 'markdown' then
    comments = { "<!--  -->" }
    col = 5
  else
    vim.print("Not supported filetype for inserting comments")
    return
  end
  require("helper").insert_lines(comments, {-1, col}, false)
end, { desc = "Insert comment" })

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
