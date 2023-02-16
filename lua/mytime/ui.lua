local popup = require("plenary.popup")
local log = require("mytime.dev").log

local function Ui(opts)
  local self = {}

  local win_id = nil
  local bufh = nil

  local function trim(s)
    return s:match("^%s*(.*%S)") or ""
  end

  local function normalise(text)
    return trim(text)
  end

  local function create_window()
    log.trace("create_window()")
    local height = opts.height or 1
    local width = opts.width or 60
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local bufnr = vim.api.nvim_create_buf(false, false)

    local id, win = popup.create(bufnr, {
      title = "MyTime",
      highlight = "MyTimeWindow",
      line = math.floor(((vim.o.lines - height) / 2) - 1),
      col = math.floor((vim.o.columns - width) / 2),
      minwidth = width,
      minheight = height,
      borderchars = borderchars,
    })

    vim.api.nvim_win_set_option(win.border.win_id, "winhl", "Normal:MytimeBorder")

    return {
      bufnr = bufnr,
      win_id = id,
    }
  end

  local function is_input_open()
    return win_id and vim.api.nvim_win_is_valid(win_id)
  end

  function self.close_input()
    log.trace("close_input()")
    if is_input_open() then
      vim.api.nvim_win_close(win_id, true)

      win_id = nil
      bufh = nil
    end
  end

  function self.open_input()
    log.trace("open_input()")
    if is_input_open() then
      return
    end

    local win_info = create_window()
    win_id = win_info.win_id
    bufh = win_info.bufnr

    vim.api.nvim_buf_set_name(bufh, "mytime-input")

    vim.api.nvim_buf_set_option(bufh, "filetype", "mytime")
    vim.api.nvim_buf_set_option(bufh, "buftype", "nofile")
    vim.api.nvim_buf_set_option(bufh, "bufhidden", "delete")
    vim.api.nvim_buf_set_option(bufh, "modifiable", true)

    -- Start in insert mode
    -- TODO: is there a better way??
    vim.api.nvim_input("i")

    -- Submit on enter (in insert mode)
    vim.keymap.set("i", "<CR>", self.add_log, { silent = true, buffer = bufh })

    -- Quit / Abort on q (in normal mode)
    vim.keymap.set("n", "q", self.close_input, { silent = true, buffer = bufh })
    -- and on click out
    vim.api.nvim_create_autocmd("BufLeave", { nested = true, once = true, callback = self.close_input, buffer = bufh })
  end

  function self.toggle_input()
    log.trace("toggle_input()")
    return is_input_open() and self.close_input() or self.open_input()
  end

  function self.add_log()
    local lines = vim.fn.getline(1, 1)
    local line = normalise(lines[1])
    if line ~= "" then
      opts.add_log(line)
    end
    self.close_input()
  end

  return self
end

return Ui
