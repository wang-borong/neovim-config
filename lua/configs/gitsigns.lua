local gitsigns = require('gitsigns')

-- Helper function to create buffer-local keymaps
local function create_buffer_map(bufnr, mode, key, action, desc)
  vim.keymap.set(mode, key, action, {
    buffer = bufnr,
    desc = desc,
  })
end

-- Navigation function that handles diff mode
local function nav_hunk(direction)
  return function()
    if vim.wo.diff then
      vim.cmd.normal({ direction, bang = true })
    else
      gitsigns.nav_hunk(direction == ']c' and 'next' or 'prev')
    end
  end
end

-- Visual mode hunk action wrapper
local function visual_hunk_action(action)
  return function()
    action({ vim.fn.line('.'), vim.fn.line('v') })
  end
end

local function on_attach(bufnr)
  -- Navigation mappings
  create_buffer_map(bufnr, 'n', ']c', nav_hunk(']c'), "Next hunk")
  create_buffer_map(bufnr, 'n', '[c', nav_hunk('[c'), "Previous hunk")

  -- Hunk actions (normal mode)
  local normal_actions = {
    ['<leader>hs'] = { gitsigns.stage_hunk, "Stage hunk" },
    ['<leader>hr'] = { gitsigns.reset_hunk, "Reset hunk" },
    ['<leader>hS'] = { gitsigns.stage_buffer, "Stage buffer" },
    ['<leader>hu'] = { gitsigns.undo_stage_hunk, "Undo stage hunk" },
    ['<leader>hR'] = { gitsigns.reset_buffer, "Reset buffer" },
    ['<leader>hp'] = { gitsigns.preview_hunk, "Preview hunk" },
    ['<leader>hb'] = { function() gitsigns.blame_line({ full = true }) end, "Blame line (full)" },
    ['<leader>hd'] = { gitsigns.diffthis, "Diff this" },
    ['<leader>hD'] = { function() gitsigns.diffthis('~') end, "Diff this (~)" },
  }

  for key, action_data in pairs(normal_actions) do
    create_buffer_map(bufnr, 'n', key, action_data[1], action_data[2])
  end

  -- Hunk actions (visual mode)
  local visual_actions = {
    ['<leader>hs'] = { gitsigns.stage_hunk, "Stage hunk (visual)" },
    ['<leader>hr'] = { gitsigns.reset_hunk, "Reset hunk (visual)" },
  }

  for key, action_data in pairs(visual_actions) do
    create_buffer_map(bufnr, 'v', key, visual_hunk_action(action_data[1]), action_data[2])
  end

  -- Toggle actions
  create_buffer_map(bufnr, 'n', '<leader>tb', gitsigns.toggle_current_line_blame, "Toggle line blame")
  create_buffer_map(bufnr, 'n', '<leader>td', gitsigns.toggle_deleted, "Toggle deleted")

  -- Text object
  create_buffer_map(bufnr, { 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', "Select hunk (text object)")
end

require("gitsigns").setup({
  on_attach = on_attach,
})
