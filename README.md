# mytime.nvim

A plugin for quickly creating timestamped journal entries in from neovim.

## About

I just wanted a way of quickly creating tiny timestamped journal entries in a
datestamped file. This is designed to work with Obsidian daily note.

## Installation

Use whatever package manager you like.

If you're using `plug`:

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'rohanorton/mytime.nvim'
```

Or, my personal favourite, `packer`:

```lua
use({
  "rohanorton/mytime.nvim",
  requires = { "nvim-lua/plenary.nvim" }
})
```

You will need to call the setup:

```lua
local mytime = require('mytime')

mytime.setup({
  -- REQUIRED: you must specify directory that files are save to
  directory = "/path/to/the/directory/you/want/files/created/in",
  -- Defaults:
  ui_height = 1,
  ui_width = 60,
})
```

Suggested keybindings:

```vim
noremap <silent> <leader>ll <Plug>mytime-add-log
noremap <silent> <leader>lr <Plug>mytime-read-log
```

## Commands

### Add Log

Opens a prompt for you journal entry.

The entry is appended to a today's log file, alongside a timestamp, on enter.

Cancelled on click outside, "q" in normal mode

Can be invoked directly using lua:

```lua
require('mytime').add_log()
```

Or it can be assigned a keybinding:

```vim
noremap <silent> <leader>ll <Plug>mytime-add-log
```

### Read Log

Prints the content of today's log file.

```lua
require('mytime').read_log()
```

Or it can be assigned a keybinding:

```vim
noremap <silent> <leader>lr <Plug>mytime-read-log
```
