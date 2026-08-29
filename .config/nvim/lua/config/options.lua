local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.autoread = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.confirm = true
opt.scrolloff = 4
opt.updatetime = 250

-- Use built-in command completion for :find and other commands.
opt.path:append("**")
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- Use ripgrep for :grep when it is installed.
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden --glob=!.git"
  opt.grepformat = "%f:%l:%c:%m"
end

-- for zz to use treesitter fold toggle
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
