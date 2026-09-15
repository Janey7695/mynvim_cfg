vim.opt.mouse = 'a'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.clipboard = 'unnamedplus'
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.showtabline = 2 -- 始终显示标签栏
vim.opt.signcolumn = "yes" -- gitsigns / 诊断占位，避免行号左右跳

vim.opt.termguicolors = true
vim.opt.background = "light"
-- insert 默认 ver25 在 latte 浅底几乎看不见；加粗竖条
vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver50-Cursor,r-cr-o:hor20-Cursor"


vim.cmd([[:let mapleader = "\<space>"]])


