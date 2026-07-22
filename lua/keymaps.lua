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

-- 窗口切换：<C-h/j/k/l> 替代 <C-w>h/j/k/l
vks('n','<C-h>','<C-w>h',opts)
vks('n','<C-j>','<C-w>j',opts)
vks('n','<C-k>','<C-w>k',opts)
vks('n','<C-l>','<C-w>l',opts)
