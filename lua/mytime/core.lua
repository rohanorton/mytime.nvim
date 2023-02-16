local log = require("mytime.dev").log
local path = require("mytime.path")
local f = string.format

local MyTime = function(opts)
  local self = {}

  local function filepath()
    local filename = opts.generate_filename()
    return path.join(opts.directory, filename)
  end

  self.add_log = function(message)
    log.trace("create_log()")

    local timestamp = opts.generate_timestamp()
    local text = f("%s - %s", timestamp, message)

    -- Append the text to file
    vim.fn.writefile({ text }, filepath(), "a")
  end

  self.read_log = function()
    log.trace("read_log()")

    -- TODO: Not the nicest ux, is it enough?
    vim.cmd("! cat " .. filepath())
  end

  return self
end

return MyTime
