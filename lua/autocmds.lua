local autocmd = vim.api.nvim_create_autocmd

autocmd("BufNewFile", {
  pattern = { "*.sh", "*.py", "*.[ch]", "*.cc", "*.cpp", "*.hpp" },
  callback = function()
    require("helper").insert_header()
  end
})

autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = { "*.[ch]", "*.cc", "*.cpp", "*.hpp" },
  callback = function()
    require("helper").update_header()
  end
})

-- Return to last cursor when file opened
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})
