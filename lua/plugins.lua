local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 工程检索范围：项目根（含 .git 或 .fzf-roots）下的 `.fzf-roots`
-- 普通行：相对目录/文件白名单
-- `!pattern`：排除，fd/rg glob（任意深度）。例：!.iac  !*UnitTests
-- `#` 开头为注释。文件不存在则搜整个仓库。不是 PCRE。
local function fzf_project_opts()
    local start = vim.fn.getcwd()
    local root = vim.fs.root(start, { ".fzf-roots", ".git" }) or start
    local opts = { cwd = root }
    local fh = io.open(root .. "/.fzf-roots", "r")
    if not fh then
        return opts
    end
    local paths, excludes = {}, {}
    for line in fh:lines() do
        line = vim.trim(line)
        if line ~= "" and line:sub(1, 1) ~= "#" then
            if line:sub(1, 1) == "!" then
                local ex = vim.trim(line:sub(2)):gsub("/+$", "")
                if ex ~= "" then
                    table.insert(excludes, ex)
                end
            else
                table.insert(paths, line)
            end
        end
    end
    fh:close()
    if #paths > 0 then
        opts.search_paths = paths
    end
    if #excludes > 0 then
        local d = require("fzf-lua.defaults").defaults
        local fd_ex, rg_globs = "", ""
        for _, ex in ipairs(excludes) do
            fd_ex = fd_ex .. " --exclude " .. vim.fn.shellescape(ex)
            local globs
            if ex:find("/", 1, true) then
                globs = { "!" .. ex, "!" .. ex .. "/**" }
            else
                -- 根目录 + 任意深度（rg 的 * 不跨 /）
                globs = {
                    "!" .. ex,
                    "!" .. ex .. "/**",
                    "!**/" .. ex,
                    "!**/" .. ex .. "/**",
                }
            end
            for _, g in ipairs(globs) do
                rg_globs = rg_globs .. " --glob " .. vim.fn.shellescape(g)
            end
        end
        opts.fd_opts = d.files.fd_opts .. fd_ex
        local rg = d.grep.rg_opts
        if rg:find("%-e%s*$") then
            opts.rg_opts = rg:gsub("%-e%s*$", "") .. rg_globs .. " -e"
        else
            opts.rg_opts = rg .. rg_globs
        end
    end
    return opts
end


require("lazy").setup({
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "latte",
            -- 默认 Cursor 是 rosewater，浅底插入竖条几乎看不见
            custom_highlights = function(colors)
                return {
                    Cursor = { fg = colors.base, bg = colors.red },
                    lCursor = { fg = colors.base, bg = colors.red },
                    CursorIM = { fg = colors.base, bg = colors.red },
                    TermCursor = { fg = colors.base, bg = colors.red },
                }
            end,
            integrations = {
                treesitter = true,
                native_lsp = { enabled = true },
                neotree = true,
                blink_cmp = true,
                fzf = true,
                illuminate = true,
                gitsigns = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin-latte")
        end,
    },


    -- 补全引擎：blink.cmp（内置 LSP/path/snippets/buffer 源 + lspkind 图标，
    -- 不再需要单独装 cmp-nvim-lsp/cmp-buffer/cmp-path/cmp-cmdline/lspkind）
    {
        "saghen/blink.cmp",
        -- 用 release tag 自动下载预编译的 Rust 模糊匹配器二进制
        version = "1.*",
        dependencies = {
            "L3MON4D3/LuaSnip", -- 片段引擎（blink 支持，沿用旧的）
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 键位：基于 default preset（C-space/C-e/C-p/C-n/C-y 等）
            -- <Tab>/<S-Tab>/<CR> 复刻 nvim-cmp super-tab；菜单仍预选第一项
            keymap = {
                preset = 'default',
                ['<Tab>'] = { 'select_next', 'show', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
                ['<CR>'] = { 'accept', 'fallback' },
                -- 菜单开着：关菜单并留在 insert；关掉了：正常 Esc 回 normal
                ['<Esc>'] = { 'hide', 'fallback' },
            },

            appearance = {
                nerd_font_variant = 'mono',
            },

            completion = {
                documentation = { auto_show = false },
            },

            -- 启用的补全源（内置，无需另装插件）
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            -- 实验性签名帮助（替代 lsp.lua 里 <C-k> 的 vim.lsp.buf.signature_help 体验更好）
            signature = { enabled = true },

            -- 优先用 Rust 模糊匹配器，下载失败时回落到 Lua 实现
            fuzzy = {
                implementation = "prefer_rust_with_warning",
            },
        },
        opts_extend = { "sources.default" },
    },

    -- LSP 管理器
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",

    -- 代码格式化
    "mhartington/formatter.nvim",

    -- 代码片段引擎（被 blink 调用，也用于你 snippets.lua 里的自定义片段）
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
    },

    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("config.neo-tree-cfg")
      end,
    },

    -- 模糊检索：文件名 / 内容 grep / buffer / LSP symbols
    -- 键位用 <space>s*，避开已占用的 <space>f（LSP 格式化）
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "FzfLua",
        keys = {
            { "<space>sf", function() require("fzf-lua").files(fzf_project_opts()) end, desc = "Find files" },
            { "<space>sg", function() require("fzf-lua").live_grep(fzf_project_opts()) end, desc = "Live grep" },
            { "<space>sg", function() require("fzf-lua").grep_visual(fzf_project_opts()) end, mode = "v", desc = "Grep selection" },
            { "<space>sw", function() require("fzf-lua").grep_cword(fzf_project_opts()) end, desc = "Grep word" },
            { "<space>sb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
            { "<space>sr", function() require("fzf-lua").oldfiles() end, desc = "Recent files" },
            { "<space>ss", function() require("fzf-lua").lsp_document_symbols() end, desc = "Doc symbols" },
            { "<space>sl", function() require("fzf-lua").blines() end, desc = "Buffer lines" },
        },
        -- <CR> 新 tab 打开（和 neo-tree open_tabnew 一致）；true 继承 ctrl-s/v/t
        opts = function()
            local actions = require("fzf-lua").actions
            return {
                actions = {
                    files = {
                        true,
                        ["enter"] = actions.file_tabedit,
                    },
                },
                lsp = {
                    jump1_action = actions.file_tabedit,
                },
                -- 当前 buffer 行跳转留在本窗，不要再开一个同样文件的 tab
                -- 不要在 picker.actions 里放 true：inherit 只对 setup.actions.files/buffers
                -- 生效，留下的 [1]=true 会被 hide profile assert 炸掉
                blines = {
                    actions = {
                        ["enter"] = actions.file_edit,
                    },
                },
            }
        end,
    },

    -- 文件内跳转：s/S 贴标签跳；f/t 由 flash 增强（VeryLazy 后生效）
    -- S 不用 flash.treesitter()（要选区不是跳点）。substitute 改用 cl
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump({
                        search = { forward = false, wrap = false, multi_window = false },
                    })
                end,
                desc = "Flash backward",
            },
        },
    },

    -- Neovim 0.12：nvim-treesitter main。装 parser；FileType 上 vim.treesitter.start 开高亮。
    -- 不启 indent/fold。objc context query 上游暂不支持，C/C++/Python/Lua 可以钉签名。
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local langs = {
                "lua", "python", "c", "cpp", "objc", "bash",
                "json", "markdown", "vim", "vimdoc", "query", "swift",
            }
            require("nvim-treesitter").install(langs)
            vim.treesitter.language.register("objc", "objcpp")
            vim.treesitter.language.register("json", "jsonc")
            vim.treesitter.language.register("bash", "sh")
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "lua", "python", "c", "cpp", "objc", "objcpp",
                    "bash", "sh", "json", "jsonc", "markdown", "vim", "swift",
                },
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },

    -- 滚进函数/类内部时把签名钉在窗口顶部（VS Code sticky scroll）
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        opts = {
            max_lines = 3,
            multiline_threshold = 1,
            mode = "cursor",
        },
    },

    -- 光标停在标识符上时，同屏其它同一符号淡高亮（LSP → treesitter → regex）
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
        config = function()
            require("illuminate").configure({
                delay = 200,
                filetypes_denylist = { "neo-tree", "qf", "mason", "lazy" },
                disable_keymaps = true,
            })
            -- plugin/*.vim 在 config 之前已按默认绑上 <A-n>/<A-p>/<A-i>
            pcall(vim.keymap.del, "n", "<A-n>")
            pcall(vim.keymap.del, "n", "<A-p>")
            pcall(vim.keymap.del, "o", "<A-i>")
            pcall(vim.keymap.del, "x", "<A-i>")
        end,
    },

    -- Git 行号旁 +/-/~；preview 用 <space>ph（避开 <space>h 切窗）
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            { "<space>ph", function() require("gitsigns").preview_hunk() end, desc = "Preview git hunk" },
        },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "-" },
                topdelete = { text = "-" },
                changedelete = { text = "~" },
                untracked = { text = "+" },
            },
        },
    },
})