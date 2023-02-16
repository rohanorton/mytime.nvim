local log = require("mytime.dev").log
local path = require("mytime.path")
local f = string.format

local MyTime = function(opts)
  local self = {}

  self.create_log = function(message)
    log.trace("create_log()")

    local filename = opts.generate_filename()
    local filepath = path.join(opts.directory, filename)

    local timestamp = opts.generate_timestamp()
    local text = f("%s - %s", timestamp, message)

    -- Append the text to file
    vim.fn.writefile({ text }, filepath, "a")
  end

  return self
end

return MyTime
