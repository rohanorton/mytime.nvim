local spy = require("luassert.spy")

local Ui = require("mytime.ui")

describe("Ui", function()
  describe(".add_log()", function()
    local ui = nil
    local callback = nil

    before_each(function()
      callback = spy.new(function() end)

      local opts = { width = 60, height = 1, add_log = callback }
      ui = Ui(opts)

      ui.open_input()
    end)

    after_each(function()
      if ui then
        ui.close_input()
      end
    end)

    it("should pass the current line to callback", function()
      local expected = "expected result text"
      vim.api.nvim_set_current_line(expected)

      ui.add_log()

      assert.spy(callback).was.called_with(expected)
    end)

    it("should not call callback with empty string", function()
      vim.api.nvim_set_current_line("")

      ui.add_log()

      assert.spy(callback).was.not_called()
    end)

    it("trims whitespace", function()
      local expected = "expected result text"
      local additional_whitespace = "\t\t\t    "
      vim.api.nvim_set_current_line(additional_whitespace .. expected .. additional_whitespace)

      ui.add_log()

      assert.spy(callback).was.called_with(expected)
    end)
  end)
end)
