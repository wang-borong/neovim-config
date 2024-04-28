require "nvchad.mappings"

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>p", "<cmd> %y+ <CR>", { desc = "copy whole file" })
map("n", "<leader>w", "<cmd> w <CR>", { desc = "save file" })
map("n", "<leader>db", "gg0vG$d", { desc = "delete the buffer" })
map("n", "<leader>s", ":Telescope grep_string<CR>", { desc = "grep string" })
map("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "enter to the location of current file" })
map({"n", "i"}, "<leader>q", "<esc>:q<CR>", { desc = "quit nvim" })
-- telescope
map("n", "<leader>te", ":Telescope <CR>", { desc = "spawn telescope" })
map("n", "<leader>tl", ":Telescope live_grep<CR>", { desc = "spawn telescope with living grep" })
-- truezen
map("n", "<leader>ta", ":TZAtaraxis <CR>", { desc = "enter ataraxis mode of truezen" })
map("n", "<leader>tm", ":TZMinimalist <CR>", { desc = "enter minimize mode of truezen" })
map("n", "<leader>tf", ":TZFocus <CR>", { desc = "enter focus mode of truezen" })
-- Gitsigns
map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

map("n", "<leader>lc",
  function()
    local cword = vim.fn.escape(vim.fn.expand('<cword>'), [[\/]])
    local cmd = string.format(":s/%s/\\\\lstinline!%s!/g", cword, cword)
    vim.cmd(cmd)
  end,
  { desc = "replace word to lstinline code"})

-- add pair
map("v", "$<", "<esc>`>a><esc>`<i<<esc>", { desc = "wrap <> with selected context" })
map("v", "$(", "<esc>`>a)<esc>`<i(<esc>", { desc = "wrap ()) with selected context" })
map("v", "$[", "<esc>`>a]<esc>`<i[<esc>", { desc = "wrap []] with selected context" })
map("v", "${", "<esc>`>a}<esc>`<i{<esc>", { desc = "wrap {} with selected context" })
map("v", '$"', '<esc>`>a"<esc>`<i"<esc>', { desc = "wrap \"\" with selected context" })
map("v", "$'", "<esc>`>a'<esc>`<i'<esc>", { desc = "wrap '' with selected context" })
map("v", "$`", "<esc>`>a`<esc>`<i`<esc>", { desc = "wrap `` with selected context" })
map("v", "$$", "$", { desc = "jump to the end of selected context" })

map("i", "jc", "/*  */<Left><Left><Left>", { desc = "insert c style comment" })
