-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    fg = "light_grey",
    italic = true,
  },
  CursorLine = {
    bg = "black2",
  },
  Visual = {
    bg = "one_bg3",
  },
  Search = {
    fg = "black",
    bg = "yellow",
  },
  IncSearch = {
    fg = "black",
    bg = "orange",
  },
  CurSearch = {
    fg = "black",
    bg = "orange",
  },
  WinSeparator = {
    fg = "line",
  },
  FloatBorder = {
    fg = "grey_fg2",
    bg = "black2",
  },
  NormalFloat = {
    bg = "black2",
  },
  Pmenu = {
    bg = "black2",
  },
  PmenuSel = {
    fg = "black",
    bg = "pmenu_bg",
  },
  DiagnosticVirtualTextError = {
    fg = "red",
    bg = "black2",
  },
  DiagnosticVirtualTextWarn = {
    fg = "yellow",
    bg = "black2",
  },
  DiagnosticVirtualTextInfo = {
    fg = "blue",
    bg = "black2",
  },
  DiagnosticVirtualTextHint = {
    fg = "teal",
    bg = "black2",
  },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
  DapBreakpoint = { fg = "red", bold = true },
  DapBreakpointCondition = { fg = "yellow", bold = true },
  DapBreakpointRejected = { fg = "grey_fg2" },
  DapLogPoint = { fg = "blue", bold = true },
  DapStopped = { fg = "green", bold = true },
  DapStoppedLine = { bg = "one_bg2" },
  LspInlayHint = { fg = "grey_fg2", bg = "black2" },
  TelescopeSelection = { bg = "one_bg2", bold = true },
  TelescopeMatching = { fg = "yellow", bold = true },
  WhichKey = { fg = "blue", bold = true },
  WhichKeyGroup = { fg = "purple" },
  WhichKeyDesc = { fg = "white" },
}

return M
