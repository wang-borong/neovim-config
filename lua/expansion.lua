-- 1. Store the original Neovim handler in a separate variable
local original_rename_handler = vim.lsp.handlers["textDocument/rename"]

-- 2. Overwrite the handler with your custom auto-saving logic
vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
  -- Call the original handler using our saved reference (avoids loop)
  if original_rename_handler then
    original_rename_handler(err, result, ctx, config)
  else
    -- Fallback to the default LSP text edit application if original isn't found
    vim.lsp.handlers["textDocument/rename"](err, result, ctx, config)
  end

  -- 3. Directly save files if the rename was successful
  if result and not err then
    vim.cmd("silent! wa")
  end
end
