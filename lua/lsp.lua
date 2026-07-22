-- LSP 配置（Neovim 0.11+ 的 vim.lsp.config / vim.lsp.enable 新范式）
-- 参见 :help lspconfig-nvim-0.11

require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require('mason-lspconfig').setup({
    -- 没装就自动装；这里写的是 mason 的 server 名，
    -- 与下面的 vim.lsp.enable 里用的是 lspconfig 名（基本一致）
    ensure_installed = { 'pylsp', 'lua_ls' },
})

-- 诊断相关的全局键位（跟旧版一致）
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- 统一用 LspAttach autocmd 给 buffer 绑键位，替代旧的 on_attach
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
    callback = function(ev)
        local bufnr = ev.buf
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format({ async = true })
        end, bufopts)
    end,
})

-- 让 LSP server 知道客户端支持 snippet 等 blink 增强能力
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- 各 server 的配置：用 vim.lsp.config 替代旧的 lspconfig.xxx.setup
-- on_attach 不再需要，键位已由上面的 LspAttach 统一处理
vim.lsp.config('lua_ls', { capabilities = capabilities })
vim.lsp.config('pylsp', { capabilities = capabilities })
vim.lsp.config('clangd', { capabilities = capabilities })

-- 真正启用这些 server
vim.lsp.enable({ 'lua_ls', 'pylsp', 'clangd' })