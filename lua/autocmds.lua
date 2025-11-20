local autocmd = vim.api.nvim_create_autocmd

-- File patterns for header insertion
local header_file_patterns = { "*.sh", "*.py", "*.[ch]", "*.cc", "*.cpp", "*.hpp" }

-- File patterns for header update
local header_update_patterns = { "*.[ch]", "*.cc", "*.cpp", "*.hpp" }

-- Filetypes that should not restore cursor position
local no_cursor_restore_filetypes = { "commit", "xxd", "gitrebase" }

-- Insert header for new files
autocmd("BufNewFile", {
  pattern = header_file_patterns,
  callback = function()
    require("helper").insert_header()
  end,
})

-- Update header for existing files
autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = header_update_patterns,
  callback = function()
    require("helper").update_header()
  end,
})

-- Restore cursor position when opening files
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local last_line = vim.fn.line('"')
    local total_lines = vim.fn.line("$")
    local filetype = vim.bo.filetype
    
    local should_restore = last_line > 1
      and last_line <= total_lines
      and filetype ~= "commit"
      and vim.tbl_contains(no_cursor_restore_filetypes, filetype) == false
    
    if should_restore then
      vim.cmd('normal! g`"')
    end
  end,
})
