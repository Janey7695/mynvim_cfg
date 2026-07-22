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
    ensure_installed = { 'pylsp', 'lua_ls', 'clangd', 'bash-language-server', 'json-lsp' },
})

-- mason-lspconfig 只负责 LSP server；formatter 须用 mason 原生 API 装
local function ensure_mason_packages(pkgs)
    local registry = require('mason-registry')
    for _, pkg in ipairs(pkgs) do
        local ok, p = pcall(registry.get_package, pkg)
        if ok and p and not p:is_installed() then
            p:install()
        end
    end
end
ensure_mason_packages({ 'stylua', 'prettier', 'shfmt', 'clang-format' })

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

-- JSON：附带 schemas for common configs（package.json/tsconfig/vscode settings…）
-- 这是 lspconfig 'jsonls' 的标准启动方式
vim.lsp.config('jsonls', {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    capabilities = capabilities,
    init_options = {
        provideFormatter = false,  -- 格式化交给 formatter.nvim，避免双份格式化干态
        documentFormatting = false,
    },
})

-- Bash：脚本补全/诊断/跳转
vim.lsp.config('bashls', {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' },
    capabilities = capabilities,
})

-- Apple Swift / ObjC / ObjC++：用 Xcode 自带的 sourcekit-lsp
-- "不要" 加入 mason 的 ensure_installed（它由 Xcode 提供）
-- 已知坑：sourcekit-lsp 期望 language id = 'objective-c' / 'objective-cpp'，
-- 而 Neovim 默认把 .m/.mm 设为 'objc'/'objcpp'，会导致 ObjC 文件不补全。
-- 用 vim.filetype.add 把 .m/.mm 映射到 sourcekit 期望的名字解决。
vim.filetype.add({
    extension = {
        ['m']   = 'objective-c',
        ['mm']  = 'objective-cpp',
        ['swift'] = 'swift',
    },
})
vim.lsp.config('sourcekit', {
    cmd = { 'xcrun', 'sourcekit-lsp' },
    filetypes = { 'swift', 'objective-c', 'objective-cpp', 'c', 'cpp' },
    root_dir = function(bufnr, on_dir)
        -- 新 API 的 root_dir 回调签名是 (bufnr, on_dir)；bufnr 是整数 buffer 号。
        -- 参见 :help vim.lsp.config
        local path = vim.api.nvim_buf_get_name(bufnr)
        -- 从文件向上找项目标记：SwiftPM / Xcode 项目 / workspace / compile db / git
        local root = vim.fs.root(path, {
            'Package.swift',
            '*.xcodeproj',
            '*.xcworkspace',
            'compile_commands.json',
            '.git',
        }) or vim.fs.dirname(path)
        on_dir(root)
    end,
    capabilities = capabilities,
})

-- 真正启用这些 server
vim.lsp.enable({ 'lua_ls', 'pylsp', 'clangd', 'sourcekit', 'jsonls', 'bashls' })
