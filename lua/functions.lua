local M = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "User commands" })
end

local function executable_or_warn(command)
  local path = vim.fn.exepath(command)
  if path == "" then
    notify(command .. " is not installed or not in PATH", vim.log.levels.ERROR)
    return nil
  end

  return path
end

local function run(command, opts)
  opts = opts or {}

  local ok, result = pcall(function()
    return vim
      .system(command, {
        stdin = opts.stdin,
        text = true,
      })
      :wait()
  end)

  if not ok then
    notify(result, vim.log.levels.ERROR)
    return nil
  end

  if result.code ~= 0 then
    local reason = vim.trim(result.stderr or "")
    notify(reason ~= "" and reason or (command[1] .. " exited with code " .. result.code), vim.log.levels.ERROR)
    return nil
  end

  return result.stdout or ""
end

local function split_output(output)
  output = output:gsub("\r\n", "\n"):gsub("\n$", "")
  if output == "" then
    return {}
  end

  return vim.split(output, "\n", { plain = true })
end

function M.text_convert(from, to, range)
  local pandoc = executable_or_warn "pandoc"
  if not pandoc then
    return
  end

  local input
  if range then
    local lines = vim.api.nvim_buf_get_lines(0, range[1] - 1, range[2], false)
    input = table.concat(lines, "\n")
  else
    input = vim.fn.getreg "+"
    if input == "" then
      notify("The system clipboard is empty", vim.log.levels.WARN)
      return
    end
  end

  local output = run({ pandoc, "--listings", "--from=" .. from, "--to=" .. to }, { stdin = input })
  if not output then
    return
  end

  local lines = split_output(output)
  if #lines == 0 then
    notify("pandoc returned no output", vim.log.levels.WARN)
    return
  end

  if range then
    vim.api.nvim_buf_set_lines(0, range[1] - 1, range[2], false, lines)
  else
    vim.api.nvim_put(lines, "", false, true)
  end
end

function M.to_utf8()
  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then
    notify("The current buffer has no file name", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    notify("Save or discard the current buffer changes before converting its encoding", vim.log.levels.WARN)
    return
  end

  local stat = vim.uv.fs_stat(filename)
  if not stat or stat.type ~= "file" then
    notify("The current buffer is not backed by a regular file", vim.log.levels.ERROR)
    return
  end

  local uchardet = executable_or_warn "uchardet"
  local iconv = executable_or_warn "iconv"
  if not uchardet or not iconv then
    return
  end

  local detected = run { uchardet, filename }
  if not detected then
    return
  end

  local encoding = vim.trim(detected)
  if encoding == "" or encoding:lower() == "unknown" then
    notify("uchardet could not determine the file encoding", vim.log.levels.ERROR)
    return
  end

  local normalized_encoding = encoding:upper():gsub("_", "-")
  if normalized_encoding == "UTF-8" or normalized_encoding == "ASCII" then
    notify "The file is already UTF-8 compatible"
    return
  end

  local temp_path = string.format("%s.nvim-iconv-%d", filename, vim.uv.os_getpid())
  local output = run { iconv, "-f", encoding, "-t", "UTF-8", "-o", temp_path, filename }
  if not output then
    pcall(vim.uv.fs_unlink, temp_path)
    return
  end

  local chmod_ok, chmod_err = vim.uv.fs_chmod(temp_path, stat.mode % 512)
  if not chmod_ok then
    pcall(vim.uv.fs_unlink, temp_path)
    notify("Failed to preserve file permissions: " .. tostring(chmod_err), vim.log.levels.ERROR)
    return
  end

  local renamed, rename_err = vim.uv.fs_rename(temp_path, filename)
  if not renamed then
    pcall(vim.uv.fs_unlink, temp_path)
    notify("Failed to replace the original file: " .. tostring(rename_err), vim.log.levels.ERROR)
    return
  end

  vim.cmd "edit!"
  notify(string.format("Converted %s from %s to UTF-8", vim.fn.fnamemodify(filename, ":t"), encoding))
end

local function command_range(opts)
  if opts.range == 0 then
    return nil
  end

  return { opts.line1, opts.line2 }
end

vim.api.nvim_create_user_command("Md2Tex", function(opts)
  M.text_convert("markdown", "latex", command_range(opts))
end, { desc = "Convert Markdown to LaTeX; use a range or the system clipboard", force = true, range = true })

vim.api.nvim_create_user_command("Tex2Md", function(opts)
  M.text_convert("latex", "markdown", command_range(opts))
end, { desc = "Convert LaTeX to Markdown; use a range or the system clipboard", force = true, range = true })

vim.api.nvim_create_user_command("ToUTF8", M.to_utf8, {
  desc = "Safely convert the current file to UTF-8",
  force = true,
})

return M
