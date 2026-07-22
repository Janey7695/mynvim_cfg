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

-- 窗口切换：<A-h/j/k/l>（Option 键 + hjkl）用在 macOS 上
-- <C-j> 在终端里和 <CR> 同码，不能用
vks('n','<A-h>','<C-w>h',opts)
vks('n','<A-j>','<C-w>j',opts)
vks('n','<A-k>','<C-w>k',opts)
vks('n','<A-l>','<C-w>l',opts)
