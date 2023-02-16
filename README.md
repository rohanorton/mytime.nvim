# mytime.nvim

A plugin for creating small journal entries in vim.

## About

I just wanted a way of quickly creating timestamped journal entries in a
datestamped file.

With this plugin you can simply invoke the `mytime-toggle-input` command,
insert comment into the popup, hit return, and it will append the comment
to a datestamped file in your specified directory.

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
noremap <silent> <leader>l <Plug>mytime-toggle-input
```
