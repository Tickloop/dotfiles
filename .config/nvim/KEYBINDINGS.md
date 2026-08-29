# Keybindings

This file records the shortcuts we want to keep while building the config one
plugin at a time.

## VS Code-style shortcuts

| Shortcut | Action | Current implementation |
| --- | --- | --- |
| `Ctrl-P` | Floating fuzzy project tree | Snacks explorer |
| `Ctrl-Shift-P` | Quick open | Floating fzf file picker with preview |
| `Ctrl-F` | Find in the current file | Floating fzf line picker |
| `Ctrl-Shift-F` | Find in project files | Floating fzf live grep with preview |
| `Ctrl-S` | Save | Built-in `:update` |
| `Ctrl-N` | New file | Built-in `:enew` |
| `Ctrl-Shift-W` | Close editor buffer | Built-in `:bdelete` |
| `Ctrl-Shift-E` | Open file explorer | Built-in netrw `:Explore` |

`Ctrl-W` stays as Neovim's window-command prefix. For example, `Ctrl-W h`
moves to the window on the left. `Ctrl-Shift-W` closes the current buffer.

The action shortcuts work from normal, insert, visual, and select modes. The
floating-terminal toggle also works from terminal mode. `Ctrl-[` remains
normal-mode-only because terminals and Neovim treat it as Escape in other
modes.

In the buffer picker, `Enter` focuses a window already showing the selected
buffer, including one in another Neovim tab. If the buffer is not visible, it
opens in the active window. Use `Ctrl-\\` to open the selected buffer in a new
vertical split, or `Ctrl-X` to close the selected buffer.

The project tree opens with focus on its file list and uses fuzzy matching when
you search. `Ctrl-/` toggles focus between the file list and search box.
`node_modules` is always hidden. Press `H` to toggle hidden files and `I` to
toggle files ignored by Git.

## Personal shortcuts

| Shortcut | Action |
| --- | --- |
| `d` / `dd` | Delete without copying |
| `x` / `xx` | Cut and copy the removed text |
| `zz` | Toggle the fold under the cursor |
| `Ctrl-H/J/K/L` | Move between windows |
| `Ctrl-U` | Navigate backward through the jumplist |
| `Ctrl-O` | Navigate forward through the jumplist |
| `Ctrl-I` | Scroll upward by half a screen |
| `Ctrl-Shift-I` | Scroll downward by half a screen |
| `gc` / `gcc` | Toggle comments for a motion or selection / current line |
| `{line}G` or `:{line}` | Jump to a line, such as `42G` or `:42` |

## Language features

These shortcuts use the language server attached to the current buffer:

| Shortcut | Action |
| --- | --- |
| `gk` | Toggle documentation; moving the cursor closes it |
| `gK` | Show the current function signature and parameter |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Peek at implementations in an fzf picker |
| `gI` | Go directly to an implementation |
| `gt` | Peek at type definitions in an fzf picker |
| `gT` | Go directly to a type definition |
| `gr` | List project-wide references and cache them for navigation |
| `[r` / `]r` | Previous / next cached reference, wrapping at either end |
| `gn` | Rename a symbol across the project |
| `ga` | Show code actions; also works on a visual selection |
| `gw` | Toggle the warning or error under the cursor |
| `[w` / `]w` | Previous / next warning or error, with a popup |
| `ge` | List all diagnostics in the current file |
| `gO` | Show symbols in the current file |
| `Ctrl-X Ctrl-O` | Request completion while inserting text |

The built-in `K`, `[d`, `]d`, `[D`, `]D`, and `Ctrl-W d` LSP mappings also
remain available. The default `grn`, `gra`, `grr`, `gri`, `grt`, and `grx`
mappings are intentionally disabled. Linux keeps `Ctrl-]` for the next tab and
`Ctrl-S` for saving, so `gd` and `gK` provide definition and signature access
without those conflicts. Go uses `gopls`, Python uses `basedpyright`, and
TypeScript uses `ts_ls`.

In Ghostty, `Alt-[` and `Alt-]` move to the previous and next terminal pane.

## Planned plugin upgrades

We are replacing the built-in tools one at a time:

1. File picker and project search — `fzf-lua` added
2. Color theme — `solaris.nvim` added
3. File explorer — `snacks.nvim` trial on `Ctrl-P`
4. Treesitter syntax and code structure — added for Lua
5. Language servers, project-wide symbol rename, and code actions — added for
   Go, Python, and TypeScript
6. Completion
7. Formatting and linting
