local lint = require "lint"

lint.linters_by_ft = {
  python = { "ruff" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
}

local function try_lint()
  if vim.bo.filetype == "" then
    return
  end

  lint.try_lint()
end

local lint_group = vim.api.nvim_create_augroup("UserLint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_group,
  callback = try_lint,
})

vim.api.nvim_create_user_command("Lint", try_lint, {})

try_lint()
