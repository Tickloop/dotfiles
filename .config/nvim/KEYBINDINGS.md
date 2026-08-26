# Keybindings

This file records the shortcuts we want to keep while building the config one
plugin at a time.

## Caps Lock through F13

Karabiner uses Caps Lock as a repeatable F13 layer. These sequences mirror the
familiar macOS shortcuts:

| Shortcut | Action |
| --- | --- |
| `F13 p` | Floating fuzzy project tree |
| `F13 Shift-p` | Command palette |
| `F13 f` | Find in the current file |
| `F13 Shift-f` | Find in project files |
| `F13 b` | Fuzzy search through open buffers |
| `F13 s` | Save |
| `F13 n` | New file |
| `F13 \\` | Create a vertical Neovim split |
| `F13 -` | Create a horizontal Neovim split |
| `F13 w` | Delete the current buffer |
| `F13 t` | Create a Neovim tab |
| `F13 [` / `F13 ]` | Previous / next Neovim tab |
| `F13 q` | Close the current Neovim tab |
| `F13 Shift-:` | Toggle a floating project terminal |
| `F13 Shift-e` | Open file explorer |
| `F13 c` | macOS copy (`Cmd-C`) |
| `F13 v` | macOS paste (`Cmd-V`) |
| `F13 Delete` | Delete one word (`Option-Delete`) |
| `F13 h/j/k/l` | Left/down/up/right arrow |
| `F13 u` | `Ctrl-Left` |
| `F13 o` | `Ctrl-Right` |

Neovim action shortcuts in the tables above work from normal, insert, visual,
and select modes. The floating-terminal toggle also works from terminal mode.
Command-line and operator-pending modes keep their native behavior.

`F13 w` removes the current buffer but preserves the split layout. Neovim's
built-in `Ctrl-W c` still closes the current split when that is what you want.

In Ghostty, Karabiner sends a fresh `F13` before every unshifted key press.
For `h/j/k/l`, Karabiner sends arrow keys directly. This makes the arrows repeat
while Caps Lock remains held and also makes them work outside Neovim. It sends
real macOS Command shortcuts for `c` and `v`, so copy and paste work system-wide.
Outside Ghostty, unmatched layer keys act like normal Command shortcuts, so
`F13 t`, `F13 w`, and `F13 \\` keep their usual behavior in Chrome and other apps.

In the buffer picker, `Enter` focuses a window already showing the selected
buffer, including one in another Neovim tab. If the buffer is not visible, it
opens in the active window. Use `F13 \\` to open the selected buffer in a new
vertical split, or `Ctrl-X` to close the selected buffer.

The project tree shows dotfiles such as `.gitignore` by default. Press `H` in
the explorer to toggle hidden files and `I` to toggle files ignored by Git.

## Personal shortcuts

| Shortcut | Action |
| --- | --- |
| `d` / `dd` | Delete without copying |
| `x` / `xx` | Cut and copy the removed text |
| `zz` | Toggle the fold under the cursor |
| `Ctrl-H/J/K/L` | Move between windows |
| `{line}G` or `:{line}` | Jump to a line, such as `42G` or `:42` |

## Language features

Neovim provides these shortcuts when a language server is attached:

| Shortcut | Action |
| --- | --- |
| `K` | Show documentation and type information |
| `Ctrl-]` | Go to definition |
| `Ctrl-W ]` | Open the definition in a split |
| `grr` | Find references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grn` | Rename a symbol across the project |
| `gra` | Show code actions; also works on a visual selection |
| `gO` | Show symbols in the current file |
| `grx` | Run the code lens under the cursor |
| `Ctrl-S` | Show signature help while inserting text |
| `Ctrl-X Ctrl-O` | Request completion while inserting text |
| `[d` / `]d` | Previous / next diagnostic |
| `[D` / `]D` | First / last diagnostic in the file |
| `Ctrl-W d` | Show the diagnostic under the cursor |

Go uses `gopls`, Python uses `basedpyright`, and TypeScript uses `ts_ls`.

## Ghostty notes

Inside Ghostty, the shifted F13 layer controls terminal structure:

| Shortcut | Ghostty action |
| --- | --- |
| `F13 Shift-\\` | Create a right-hand split |
| `F13 Shift--` | Create a lower split |
| `F13 Shift-t` | Create a Ghostty tab |
| `F13 Shift-w` | Close the current Ghostty pane |

`F13 n` remains Ghostty's next-tab shortcut. The unshifted forms are passed to
Neovim, where they manage Neovim windows and tabs.

## Planned plugin upgrades

We are replacing the built-in tools one at a time:

1. File picker and project search — `fzf-lua` added
2. Color theme — `solaris.nvim` added
3. File explorer — `snacks.nvim` trial on `F13 p`
4. Treesitter syntax and code structure — added for Lua
5. Language servers, project-wide symbol rename, and code actions — added for
   Go, Python, and TypeScript
6. Completion
7. Formatting and linting
