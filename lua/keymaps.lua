local opts = {
    noremap = true,
    silent = true,
}
local vks = vim.keymap.set

local leaderKey = '<space>'
vks('i','jj','<esc>',opts)
vks('n',leaderKey..'ec',':vsplit $MYVIMRC<CR>',opts)
vks('n',leaderKey..'sc',':source $MYVIMRC<CR>',opts)
vks('n',leaderKey..'<C-j>',':resize -2<CR>',opts)
vks('n',leaderKey..'<C-k>',':resize +2<CR>',opts)
vks('n',leaderKey..'<C-l>',':vertical resize -2<CR>',opts)
vks('n',leaderKey..'<C-h>',':vertical resize +2<CR>',opts)
vks('n','<space><tab>',':tabNext<CR>',opts)
