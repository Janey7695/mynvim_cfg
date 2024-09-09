local opts = {
    noremap = true,
    silent = true,
}
local vks = vim.keymap.set

local leaderKey = '<space>'
vks('i','jj','<esc>',opt)
vks('n',leaderKey..'ev',':vsplit $MYVIMRC<CR>',opt)
vks('n',leaderKey..'sv',':source $MYVIMRC<CR>',opt)
vks('n',leaderKey..'<C-j>',':resize -2<CR>',opts)
vks('n',leaderKey..'<C-k>',':resize +2<CR>',opts)
vks('n',leaderKey..'<C-l>',':vertical resize -2<CR>',opts)
vks('n',leaderKey..'<C-h>',':vertical resize +2<CR>',opts)
vks('n','<space><tab>',':tabNext<CR>',opts)
