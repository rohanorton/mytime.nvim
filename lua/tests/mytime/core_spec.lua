local MyTime = require("mytime.core")
local f = string.format

local function path_exists(path)
  return vim.fn.empty(vim.fn.glob(path)) == 0
end

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function mktemp(suffix)
  local res = vim.fn.system(f('mktemp -d --suffix="__%s"', suffix))
  return vim.fn.resolve(trim(res))
end

describe("MyTime", function()
  describe(".create_log()", function()
    -- SETUP --
    local tmp_test_dir = mktemp("mytime.nvim")
    -- END SETUP --

    local expected_filename = nil
    local expected_timestamp = nil
    local mytime = nil

    before_each(function()
      local generate_filename = function()
        return expected_filename
      end

      expected_filename = "2023-02-15.md"

      local generate_timestamp = function()
        return expected_timestamp
      end
      expected_timestamp = "10:03"

      mytime = MyTime({
        generate_filename = generate_filename,
        generate_timestamp = generate_timestamp,
        directory = tmp_test_dir,
      })
    end)

    after_each(function()
      -- Clean up created files
      vim.fn.system("rm " .. tmp_test_dir .. "/*")
    end)

    it("creates file when first called", function()
      assert(not path_exists(tmp_test_dir .. "/" .. expected_filename), "File should not exist before function run")

      mytime.create_log("initial note")

      assert(path_exists(tmp_test_dir .. "/" .. expected_filename), "File should exist after function run")
    end)

    it("appends note to file, with timestamp", function()
      local msg = "initial note"
      mytime.create_log(msg)

      local actual = vim.fn.readfile(tmp_test_dir .. "/" .. expected_filename)
      local expected = { "10:03 - initial note" }
      assert.are.same(actual, expected)
    end)

    it("adds multiple notes", function()
      mytime.create_log("1")
      mytime.create_log("2")
      mytime.create_log("3")

      local actual = vim.fn.readfile(tmp_test_dir .. "/" .. expected_filename)
      local expected = {
        "10:03 - 1",
        "10:03 - 2",
        "10:03 - 3",
      }

      assert.are.same(actual, expected)
    end)

    it("has protection against simple shell injection attack", function()
      -- Initial naive implementation used shell commands that made this possible
      mytime.create_log("boring'; echo 'evil")

      local actual = vim.fn.readfile(tmp_test_dir .. "/" .. expected_filename)
      local not_expected = { "evil" }

      assert.are.not_same(actual, not_expected)
    end)

    -- TEARDOWN --

    -- Delete tmp dir
    vim.fn.system("rm -rf " .. tmp_test_dir)

    -- END TEARDOWN --
  end)
end)
