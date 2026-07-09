local lint = require "lint"

lint.linters_by_ft = {
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  go = { "golangcilint" },
  kotlin = { "ktlint" },
}

local fast_lint_filetypes = {
  bash = true,
  sh = true,
}

local function try_lint(filter)
  if vim.bo.filetype == "" then
    return
  end

  if filter and not filter[vim.bo.filetype] then
    return
  end

  lint.try_lint()
end

local lint_group = vim.api.nvim_create_augroup("UserLint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
  group = lint_group,
  callback = function()
    try_lint(fast_lint_filetypes)
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = lint_group,
  callback = function()
    try_lint()
  end,
})

vim.api.nvim_create_user_command("Lint", function()
  try_lint()
end, {})

try_lint()
