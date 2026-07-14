local M = {}

function M.setup()
  require("harpoon"):setup {}
end

function M.open_telescope()
  local harpoon_list = require("harpoon"):list()
  local file_paths = {}

  for _, item in ipairs(harpoon_list.items) do
    table.insert(file_paths, item.value)
  end

  local telescope_config = require("telescope.config").values
  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table {
        results = file_paths,
      },
      previewer = telescope_config.file_previewer {},
      sorter = telescope_config.generic_sorter {},
    })
    :find()
end

return M
