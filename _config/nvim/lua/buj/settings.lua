vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.nu = true
vim.o.rnu = true

vim.o.ai = true
vim.o.et = true
vim.o.wrap = false

vim.o.ts = 4
vim.o.sw = 4
vim.o.tw = 130

vim.opt.termguicolors = true

vim.g.mapleader = vim.keycode '<space>'

vim.cmd [[set clipboard+=unnamedplus]]
vim.cmd [[set path+=** wildignore+=*/node_modules/* wildignore+=*/target/* wildignore+=*/build/*]]

vim.o.guifont = 'FantasqueSansM Nerd Font:h13'
