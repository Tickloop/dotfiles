# Neovim config

A small Neovim 0.12 config built from plain Lua.

There is no LazyVim distribution and no lazy.nvim plugin manager. Plugins are
added one at a time with Neovim's built-in `vim.pack` support in
`lua/config/plugins.lua`.

See [KEYBINDINGS.md](KEYBINDINGS.md) for the shortcuts we are keeping and the
plugin plan.

## Installed plugins

- `fzf-lua` — floating fuzzy search with file previews
- `gitsigns.nvim` — Git change markers and hunk actions inside buffers
- `snacks.nvim` — temporary fuzzy project-tree explorer
- `solaris.nvim` — black and gold color theme
