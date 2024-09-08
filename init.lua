require'basic_config'
require'keymaps'
require'snippets'
print(">^.^< happy coding mio~")

vim.cmd([[autocmd BufNewFile * :write]])

vim.cmd([[set statusline=%f-%r%m%=%y-%l/%L-0vo]])

