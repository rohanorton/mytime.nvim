local Ui = require("mytime.ui")
local MyTime = require("mytime.core")

local mytime = nil
local ui = nil

local function generate_filename()
  local date = os.date("%Y-%m-%d")
  return string.format("%s.md", date)
end

local function generate_timestamp()
  return os.date("%H:%M")
end

local function add_defaults(opts)
  opts.generate_filename = opts.generate_filename or generate_filename
  opts.generate_timestamp = opts.generate_timestamp or generate_timestamp
  opts.ui_height = opts.ui_height or 1
  opts.ui_width = opts.ui_width or 60
end

local function validate(opts)
  if not opts.directory then
    error("ValidationError: `directory` argument required.")
  end
end

local M = {}

M.setup = function(opts)
  opts = opts or {}
  validate(opts)
  add_defaults(opts)

  mytime = MyTime(opts)

  ui = Ui({
    height = opts.ui_height,
    width = opts.ui_width,
    write_entry_to_file = mytime.create_log,
  })
end

M.cleanup = function()
  mytime = nil
  ui = nil
end

M.toggle_input = function()
  if ui then
    ui.toggle_input()
  end
end

return M
