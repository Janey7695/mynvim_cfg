require'basic_config'
require'keymaps'
require'snippets'
require'plugins'
require'monokai'.setup{ palette = require'monokai'.pro}
require'lsp'
print(">^.^< happy coding mio~")

vim.cmd([[autocmd BufNewFile * :write]])

vim.cmd([[set statusline=%f-%r%m%=%y-%l/%L-0vo]])

