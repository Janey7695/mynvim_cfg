require'basic_config'
require'keymaps'
require'snippets'
require'plugins'
require'lsp'
require'config.neo-tree-cfg'
require'config.nvim-formatter-cfg'
print(">^.^< happy coding mio~")

vim.cmd([[autocmd BufNewFile * :write]])

vim.cmd([[set statusline=%f-%r%m%=%y-%l/%L-0vo]])