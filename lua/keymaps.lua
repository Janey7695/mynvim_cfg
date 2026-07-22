local opts = {
    noremap = true,
    silent = true,
}
local vks = vim.keymap.set

local leaderKey = '<space>'
vks('i','jj','<esc>',opts)
vks('n',leaderKey..'ec',':vsplit $MYVIMRC<CR>',opts)
vks('n',leaderKey..'sc',':source $MYVIMRC<CR>',opts)
vks('n','<C-Down>',':resize -5<CR>',opts)
vks('n','<C-Up>',':resize +5<CR>',opts)
vks('n','<C-Left>',':vertical resize +5<CR>',opts)
vks('n','<C-Right>',':vertical resize -5<CR>',opts)
vks('n','<space><tab>',':tabNext<CR>',opts)

-- 窗口切换：<space>hjkl（和 resize 的 <space>HJKL 互补不冲突，小写切窗、大写调大小）
vks('n',leaderKey..'h','<C-w>h',opts)
vks('n',leaderKey..'j','<C-w>j',opts)
vks('n',leaderKey..'k','<C-w>k',opts)
vks('n',leaderKey..'l','<C-w>l',opts)
