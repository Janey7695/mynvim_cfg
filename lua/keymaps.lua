local opts = {
    noremap = true,
    silent = true,
}
local vks = vim.keymap.set

local leaderKey = '<space>'
vks('i','jj','<esc>',opt)
vks('n',leaderKey..'ev',':vsplit $MYVIMRC<CR>',opt)
vks('n',leaderKey..'sv',':source $MYVIMRC<CR>',opt)
