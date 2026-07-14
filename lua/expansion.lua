local original_rename_handler = vim.lsp.handlers["textDocument/rename"]

local function changed_uris(workspace_edit)
  local uris = {}

  for uri in pairs(workspace_edit.changes or {}) do
    uris[uri] = true
  end

  for _, change in ipairs(workspace_edit.documentChanges or {}) do
    if change.textDocument and change.textDocument.uri then
      uris[change.textDocument.uri] = true
    end
  end

  return uris
end

local function save_changed_buffers(uris)
  for uri in pairs(uris) do
    local filename = vim.uri_to_fname(uri)
    local bufnr = vim.fn.bufnr(filename, false)

    if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified then
      local ok, err = pcall(vim.api.nvim_buf_call, bufnr, function()
        vim.cmd "silent update"
      end)

      if not ok then
        vim.notify(string.format("Failed to save renamed file %s: %s", filename, err), vim.log.levels.ERROR)
      end
    end
  end
end

vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
  local uris = result and changed_uris(result) or {}
  local response

  if original_rename_handler then
    response = original_rename_handler(err, result, ctx, config)
  elseif not err and result then
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_workspace_edit(result, client and client.offset_encoding or "utf-16")
  end

  if result and not err then
    vim.schedule(function()
      save_changed_buffers(uris)
    end)
  end

  return response
end
