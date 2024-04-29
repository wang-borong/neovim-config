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
map("n", "<leader>db", "gg0vG$d", { desc = "Delete the buffer" })
map("n", "<leader>s", ":Telescope grep_string<CR>", { desc = "Telescope grep_string" })
map("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Enter into the directory of the current file" })
map("n", "<leader>q", "<esc>:q<CR>", { desc = "Quit nvim" })
-- telescope
map("n", "<leader>te", ":Telescope <CR>", { desc = "Spawn telescope" })
map("n", "<leader>tl", ":Telescope live_grep<CR>", { desc = "Telescope live_grep" })
-- truezen
map("n", "<leader>ta", ":TZAtaraxis <CR>", { desc = "Enter ataraxis mode of truezen" })
map("n", "<leader>tm", ":TZMinimalist <CR>", { desc = "Enter minimize mode of truezen" })
map("n", "<leader>tf", ":TZFocus <CR>", { desc = "Enter focus mode of truezen" })

-- biffer navigation
map("n", "<A-j>", function()
  require("nvchad.tabufline").next()
end, { desc = "Goto next buffer" })
map("n", "<A-k>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Goto prev buffer" })

-- replace word under cursor
map("n", "<leader>fw", function()
  local cword = vim.fn.escape(vim.fn.expand('<cword>'), [[\/]])
  local ft = vim.bo.filetype
  if ft == 'tex' then
    local cmd = string.format(":s/%s/\\\\lstinline!%s!/g", cword, cword)
    vim.cmd(cmd)
  elseif ft == 'markdown' then
    local cmd = string.format(":s/%s/`%s`/g", cword, cword)
    vim.cmd(cmd)
  else
    vim.fn.feedkeys(string.format(":s/%s/%s/", cword, cword))
  end
end, { desc = "Add characters around a word" })

map("n", "<leader>cs", function()
  local save_cursor = vim.fn.getpos(".")
  local old_query = vim.fn.getreg('/')
  vim.cmd([[silent! %s/\s\+$//e]])
  vim.fn.setpos('.', save_cursor)
  vim.fn.setreg('/', old_query)
end, { desc = "Clean extra space" })

map("n", "<leader>U", function()
  local cword = vim.fn.escape(vim.fn.expand('<cword>'), [[\/]])
  local function upper_case(f, r)
    return f:upper()..r:lower()
  end
  local Cword = string.gsub(cword, "(%a)([%w_']*)", upper_case)
  vim.cmd(string.format(":s/%s/%s/", cword, Cword))
end, { desc = "Uppercase the string under the cursor" })

-- add pair
map("v", "$<", "<esc>`>a><esc>`<i<<esc>", { desc = "Wrap <> with selected text" })
map("v", "$(", "<esc>`>a)<esc>`<i(<esc>", { desc = "Wrap ()) with selected text" })
map("v", "$[", "<esc>`>a]<esc>`<i[<esc>", { desc = "Wrap []] with selected text" })
map("v", "${", "<esc>`>a}<esc>`<i{<esc>", { desc = "Wrap {} with selected text" })
map("v", '$"', '<esc>`>a"<esc>`<i"<esc>', { desc = "Wrap \"\" with selected text" })
map("v", "$'", "<esc>`>a'<esc>`<i'<esc>", { desc = "Wrap '' with selected text" })
map("v", "$`", "<esc>`>a`<esc>`<i`<esc>", { desc = "Wrap `` with selected text" })
map("v", "$$", "$", { desc = "Jump to the EOL in visual mode" })

local function visual_selection(replace)
  local saved_reg = vim.fn.getreg('"')
  vim.cmd("normal! vgvy")

  local pattern = vim.fn.escape(vim.fn.getreg('"'), "\\/.*'$^~[]")
  pattern = vim.fn.substitute(pattern, "\n$", "", "")

  if replace == true then
    vim.fn.feedkeys(":%s" .. '/' .. pattern .. '/')
  end

  vim.fn.setreg("/", pattern)
  vim.fn.setreg('"', saved_reg)
end
-- Visual mode pressing * or # searches for the current selection
-- Super useful! From an idea by Michael Naumann
map("v", "*", function()
  visual_selection(false)
  vim.cmd(string.format("/%s", vim.fn.getreg("/")))
end, { desc = "Forward search for the selected text" })
map("v", "#", function()
  visual_selection(false)
  vim.cmd(string.format("?%s", vim.fn.getreg("/")))
end, { desc = "Backward search for the selected text" })
-- When you press <leader>r you can search and replace the selected text
map("v", "<leader>r", function()
  visual_selection(true)
end, { desc = "Search and replace the selected text" })

map("i", "jc", "/*  */<Left><Left><Left>", { desc = "Insert c style comment" })
