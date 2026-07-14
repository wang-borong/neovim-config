local autocmd = vim.api.nvim_create_autocmd
local user_group = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

local header_file_patterns = { "*.sh", "*.py", "*.[ch]", "*.cc", "*.cpp", "*.cxx", "*.hh", "*.hpp", "*.hxx" }
local header_update_patterns = { "*.[ch]", "*.cc", "*.cpp", "*.cxx", "*.hh", "*.hpp", "*.hxx" }
local no_cursor_restore_filetypes = {
  commit = true,
  gitrebase = true,
  xxd = true,
}

autocmd("BufNewFile", {
  group = user_group,
  pattern = header_file_patterns,
  callback = function()
    require("helper").insert_header()
  end,
})

-- Avoid modifying files merely by opening them; refresh managed headers only when saving.
autocmd("BufWritePre", {
  group = user_group,
  pattern = header_update_patterns,
  callback = function()
    require("helper").update_header()
  end,
})

autocmd("BufReadPost", {
  group = user_group,
  pattern = "*",
  callback = function()
    local last_line = vim.fn.line '"'
    local total_lines = vim.fn.line "$"

    if last_line > 1 and last_line <= total_lines and not no_cursor_restore_filetypes[vim.bo.filetype] then
      vim.cmd 'normal! g`"'
    end
  end,
})
