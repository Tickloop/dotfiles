# Keybindings

This file records the shortcuts we want to keep while building the config one
plugin at a time.

## VS Code-style shortcuts

| Shortcut | Action | Current implementation |
| --- | --- | --- |
| `Ctrl-P` | Quick open | Floating fzf file picker with preview |
| `Ctrl-Shift-P` | Command palette | Floating fzf command picker |
| `Ctrl-F` | Find in the current file | Floating fzf line picker |
| `Ctrl-Shift-F` | Find in project files | Floating fzf live grep with preview |
| `Ctrl-S` | Save | Built-in `:update` |
| `Ctrl-N` | New file | Built-in `:enew` |
| `Ctrl-Shift-W` | Close editor buffer | Built-in `:bdelete` |
| `Ctrl-Shift-E` | Open file explorer | Built-in netrw `:Explore` |

`Ctrl-W` stays as Neovim's window-command prefix. For example, `Ctrl-W h`
moves to the window on the left. `Ctrl-Shift-W` closes the current buffer.

## Caps Lock through F13

Karabiner uses Caps Lock as a repeatable F13 layer. These sequences mirror the
familiar macOS shortcuts:

| Shortcut | Action |
| --- | --- |
| `F13 p` | Quick open |
| `F13 Shift-p` | Command palette |
| `F13 f` | Find in the current file |
| `F13 Shift-f` | Find in project files |
| `F13 s` | Save |
| `F13 n` | New file |
| `F13 w` | Close editor buffer |
| `F13 Shift-e` | Open file explorer |
| `F13 c` | macOS copy (`Cmd-C`) |
| `F13 v` | macOS paste (`Cmd-V`) |
| `F13 Delete` | Delete one word (`Option-Delete`) |
| `F13 h/j/k/l` | Left/down/up/right arrow |
| `F13 u` | `Ctrl-Left` |
| `F13 o` | `Ctrl-Right` |

For normal shortcut keys, Karabiner sends a fresh `F13` before every key press.
For `h/j/k/l`, Karabiner sends arrow keys directly. This makes the arrows repeat
while Caps Lock remains held and also makes them work outside Neovim. It sends
real macOS Command shortcuts for `c` and `v`, so copy and paste work system-wide.

## Personal shortcuts

| Shortcut | Action |
| --- | --- |
| `d` / `dd` | Delete without copying |
| `x` / `xx` | Cut and copy the removed text |
| `zz` | Toggle the fold under the cursor |
| `Ctrl-H/J/K/L` | Move between windows |

## Ghostty notes

Ghostty uses Command for its own actions. The Neovim shortcuts above use
Control, so they do not need Ghostty overrides. Current Ghostty actions include
`Cmd-N` for the next tab, `Cmd-F` for terminal search, `Cmd-Shift-P` for its
command palette, and `Cmd-W` for closing the current terminal surface.

## Planned plugin upgrades

We are replacing the built-in tools one at a time:

1. File picker and project search — `fzf-lua` added
2. Color theme — `solaris.nvim` added
3. File explorer
4. Syntax highlighting
5. Language servers and completion
6. Formatting and linting
