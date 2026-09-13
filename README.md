# todo.nvim

Toggle TODO/DONE checkboxes in Neovim with optional `CLOSED:` timestamps.

## Features

- `TodoToggle` command — toggle between `[TODO]` and `[DONE]`
- Adds `CLOSED: [YYYY-MM-DD ...]` timestamp when marking DONE
- Works on any line: non-checkbox lines become `[TODO]`
- Respects buffer indentation (tabs or spaces)

## Usage

### Command

```
:TodoToggle
```

### Lua API

```lua
require("todo").toggle()
```

### Behaviour
| State | Action | Result |
|-------|--------|--------|
| `- [TODO] task` | `:TodoToggle` | `- [DONE] task` + `CLOSED: [2025-01-15 Wed 14:30]` |
| `- [DONE] task` | `:TodoToggle` | `- [TODO] task` + removes `CLOSED:` line |
| `anything else` | `:TodoToggle` | `- [TODO] anything else` |

## Installation

```lua
-- lazy.nvim
{
  "MatthiasBenaets/todo.nvim",
  cmd = "TodoToggle",
  keys = { { "n", "<leader>tt", "<cmd>TodoToggle<CR>", desc = "Toggle TODO/DONE" } },
}
```
