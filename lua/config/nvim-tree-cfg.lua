vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true


local api = require'nvim-tree.api'
vim.keymap.set('n','<space>e',':NvimTreeToggle<CR>',{noremap = true,silent = true,nowait = true})
api.events.subscribe(api.events.Event.FileCreated,function (file)
    vim.cmd("tabnew " .. file.fname)
end)
local function my_on_attach(bufnr)
   local function opts(desc)
       return { desc = 'nvim-tree: ' .. desc , buffer = bufnr,noremap = true,silent = true,nowait = true}
   end 
   local ok,lapi = pcall(require,"nvim-tree.api")
   assert(ok,"api module is not found")
    lapi.config.mappings.default_on_attach(bufnr)
   vim.keymap.set('n',"<CR>",lapi.node.open.tab_drop,opts("Tab drop"))
   vim.keymap.set('n', '<C-t>', lapi.tree.change_root_to_parent,        opts('Up'))
   vim.keymap.set('n', '?',     lapi.tree.toggle_help,                  opts('Help'))
end

require("nvim-tree").setup({
    on_attach = my_on_attach,
    auto_close = true,
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})
