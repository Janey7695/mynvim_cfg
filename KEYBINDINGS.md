# Neovim 配置说明

本文档记录了 `~/.config/nvim` 这套配置里**已启用的插件**和**已配置的快捷键**，方便随时查阅。
Leader 键统一为 **空格 `<space>`**。

> 配置入口：`init.lua` → 依次加载 `basic_config` / `keymaps` / `snippets` / `plugins` / `monokai` / `lsp` / `config.nvim-tree-cfg` / `config.nvim-formatter-cfg`。

---

## 一、插件清单

用 [`lazy.nvim`](https://github.com/folke/lazy.nvim) 管理，定义在 `lua/plugins.lua`。

| 插件 | 作用 |
|---|---|
| [`tanvirtin/monokai.nvim`](https://github.com/tanvirtin/monokai.nvim) | 主题，使用 `pro` 调色板 |
| [`saghen/blink.cmp`](https://github.com/saghen/blink.cmp) (v1.*) | **补全引擎**。内置 LSP / path / snippets / buffer 四个补全源，并自带 lspkind 风格的图标；用 Rust + SIMD 模糊匹配器（失败自动回落 Lua） |
| [`L3MON4D3/LuaSnip`](https://github.com/L3MON4D3/LuaSnip) (v2.*) | 代码片段引擎，被 blink.cmp 调用展开 snippet 候选 |
| [`williamboman/mason.nvim`](https://github.com/williamboman/mason.nvim) | LSP / formatter / linter 的"包管理器"，对应 `:Mason` 浮窗 |
| [`williamboman/mason-lspconfig.nvim`](https://github.com/williamboman/mason-lspconfig.nvim) | mason ↔ lspconfig 之间的桥；自动安装 `pylsp` / `lua_ls` / `clangd` / `bash-language-server` / `json-lsp` |
| [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) | 各 LSP server 的默认配置表（配合内置 `vim.lsp.config` 使用） |
| [`mhartington/formatter.nvim`](https://github.com/mhartington/formatter.nvim) | 保存时自动格式化（Lua→stylua, C/C++→clang-format, JSON→prettier, Bash/sh→shfmt, 全部→去行尾空白） |
| [`nvim-neo-tree/neo-tree.nvim`](https://github.com/nvim-neo-tree/neo-tree.nvim) (v3.x) | 文件树侧栏，内置 Git 状态、诊断图标 |
| [`nvim-lua/plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) + [`MunifTanjim/nui.nvim`](https://github.com/MunifTanjim/nui.nvim) | neo-tree 依赖的两个库（由 lazy 管理） |
| [`nvim-tree/nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons) | 文件类型图标 |
| [`ibhagwan/fzf-lua`](https://github.com/ibhagwan/fzf-lua) | **模糊检索**。文件名 / live grep / 选区 / 光标词 / buffer / 最近文件 / 当前文件 LSP symbols。依赖本机 `fzf` + `fd` + `rg` |
| [`folke/flash.nvim`](https://github.com/folke/flash.nvim) | **文件内跳转**。`s`/`S` 贴标签跳；默认增强 `f`/`t`/`F`/`T`。`S` 不用 treesitter 选区 |
| [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) (`main`) | 语法树 parser。高亮 `vim.treesitter.start()`；不启 indent/fold。需本机 `tree-sitter` CLI + C 编译器 |
| [`nvim-treesitter/nvim-treesitter-context`](https://github.com/nvim-treesitter/nvim-treesitter-context) | 滚进函数/类时把签名钉在窗口顶部。objc 的 context query 暂不支持 |

> 已迁走的旧插件：`nvim-cmp` / `cmp-nvim-lsp` / `cmp-buffer` / `cmp-path` / `cmp-cmdline` / `lspkind.nvim`，全部由 blink.cmp 内置功能替代。

### 启用的 LSP server

通过 `vim.lsp.enable()` 启用（见 `lua/lsp.lua`）：

| Server | 语言 | 安装方式 |
|---|---|---|
| `lua_ls` | Lua（也用于编辑 Neovim 配置本身） | mason 自动 |
| `pylsp` | Python | mason 自动 |
| `clangd` | C / C++ | mason 自动 |
| `jsonls` | JSON / JSONC | mason 自动 |
| `bashls` | Bash / sh | mason 自动 |
| `sourcekit` | Swift / ObjC / ObjC++ | Xcode 自带 |

> 注意：Neovim 0.12 把 `.m` 默认成 `matlab`。配置里映射为 `objc` / `objcpp` 以加载 `syntax/objc.vim`。sourcekit-lsp 要的 language id `objective-c` / `objective-cpp` 由 nvim-lspconfig 的 `get_language_id` 转换；不要把 filetype 设成 `objective-c`（没有对应 syntax 文件）。

---

## 二、基础编辑选项

定义在 `lua/basic_config.lua`。

- 鼠标全开（`mouse=a`）、系统剪贴板共享（`unnamedplus`）
- 相对行号 + 行号列宽 3
- Tab = 4 空格，展开 tab；搜索高亮关闭
- **Leader 键 = `<space>`**

---

## 三、快捷键

### 1. 通用快捷键（`lua/keymaps.lua`）

| 模式 | 按键 | 动作 |
|---|---|---|
| insert | `jj` | 回到 normal 模式（替代 Esc） |
| normal | `<space>ec` | 垂直分屏打开配置 `$MYVIMRC` |
| normal | `<space>sc` | `:source $MYVIMRC` 重新加载配置 |
| normal | `<space><C-j>` / `<C-k>` | 窗口高度 −2 / +2 |
| normal | `<space><C-h>` / `<C-l>` | 窗口宽度 +2 / −2（注意 h 是 +、l 是 −） |
| normal | `<space><Tab>` | `:tabNext` 切到下一个 tab |

### 2. 补全快捷键（blink.cmp，insert 模式）

| 按键 | 动作 |
|---|---|
| `<Tab>` | 菜单可见→选下一个；不可见→触发补全；都没→Neovim 默认 Tab |
| `<S-Tab>` | 菜单可见→选上一个；在 snippet 内→跳回上一占位符；都没→fallback |
| `<CR>` | 接受当前选中的候选；无候选→正常回车换行 |
| `<C-space>` | 手动打开补全菜单 / 文档 |
| `<C-e>` | 隐藏补全菜单 |
| `<C-y>` | 选中并接受当前候选 |
| `<C-b>` / `<C-f>` | 文档窗口上下滚 4 行 |
| `<C-k>` | 切换签名帮助窗口 |
| `<C-n>` / `<C-p>` | 选下一个 / 上一个候选 |
| `<Up>` / `<Down>` | 选下一个 / 上一个候选 |

### 3. LSP 诊断快捷键（`lua/lsp.lua`，normal 模式）

| 按键 | 动作 |
|---|---|
| `<space>e` | 打开浮动诊断窗口 |
| `<space>q` | 把诊断放入 location list |
| `[d` / `]d` | 上一个 / 下一个诊断 |

### 4. LSP buffer 快捷键（在 `LspAttach` 时绑定，normal 模式）

| 按键 | 动作 |
|---|---|
| `gD` | 跳到 declaration（声明） |
| `gd` | 跳到 definition（定义） |
| `K` | hover 文档 |
| `gi` | implementation |
| `<C-k>` | signature help |
| `<space>wa` / `wr` / `wl` | 添加 / 移除 / 列出 workspace folder |
| `<space>D` | type definition |
| `<space>rn` | rename 符号 |
| `<space>ca` | code action |
| `gr` | references |
| `<space>f` | LSP 格式化（异步） |

> ⚠️ 注意有重叠：`<C-k>` 既在 blink 里是"切换签名窗口"，又在 LSP 里是 `signature_help`。LSP 的 buffer 键位只在某个 LSP 客户端附着后才绑，blink 的补全键在 insert 时触发，两者默认场景错开，基本不冲突；但在 LSP 的浮窗签名体验上，blink 的签名功能更现代。

### 5. 文件树 neo-tree（`lua/config/neo-tree-cfg.lua`）

| 按键 | 模式 | 动作 |
|---|---|---|
| `<space>o` | normal | `:Neotree filesystem toggle` 打开/关闭文件树 |
| `<CR>` | 文件树内 | 打开文件 |
| `<bs>` | 文件树内 | 回到父目录 |
| `?` | 文件树内 | 切换帮助说明 |
| `a` | 文件树内 | 新建文件 |
| `d` | 文件树内 | 删除文件 |
| `r` | 文件树内 | 重命名 |
| `c` / `m` | 文件树内 | 复制 / 移动 |
| `/` | 文件树内 | 模糊搜索文件 |
| `H` | 文件树内 | 切换隐藏文件的显示 |
| `<` / `>` | 文件树内 | 上一个 / 下一个源 |

设置：宽 30 列，左栏，大小写敏感排序，显示 dotfiles，Git 状态图标，当前文件自动跟随。

### 6. 模糊检索 fzf-lua（`lua/plugins.lua`）

工程级检索走 fzf-lua；neo-tree 的 `/` 只过滤当前树节点，不能替代。
键位用 `<space>s*`，**不用** `<space>f*`：`<space>f` 已是 LSP 格式化，再绑 `ff` 会让格式化等 `timeoutlen`。
项目根放 `.fzf-roots`：普通行是白名单目录/文件，`!name` 排除任意深度的该名（如 `!.iac`）。没有该文件则搜整个仓库。不写进插件。

| 模式 | 按键 | 动作 |
|---|---|---|
| normal | `<space>sf` | 文件名模糊打开（`fd`） |
| normal | `<space>sg` | 全仓 live grep（`rg`，边打边搜） |
| visual | `<space>sg` | 用当前选区当查询做 grep |
| normal | `<space>sw` | 搜光标下的词 |
| normal | `<space>sb` | 已开 buffer |
| normal | `<space>sr` | 最近打开的文件 |
| normal | `<space>ss` | 当前文件 LSP document symbols |
| normal | `<space>sl` | 当前 buffer 模糊搜行（`blines`，当前窗跳转） |

浮窗内：

| 按键 | 动作 |
|---|---|
| `<CR>` | 新 tab 打开（和 neo-tree `<CR>` = `open_tabnew` 一致；`<space>sl` 例外：当前窗） |
| `<C-t>` | 新 tab 打开 |
| `<C-s>` | 水平分屏 |
| `<C-v>` | 垂直分屏 |
| `<Esc>` | 关闭 |

也可 `:FzfLua files` / `:FzfLua live_grep` / `:FzfLua blines` 等。文本匹配，不是 AST/语义搜索。

### 7. 文件内跳转 flash.nvim（`lua/plugins.lua`）

当前屏落点。`s` 覆盖默认 substitute（改用 `cl`）；`S` 覆盖 `cc` 式整行替换（改用 `cc`）。

| 模式 | 按键 | 动作 |
|---|---|---|
| n / x / o | `s` | 双向 flash jump（打字符 → 标签 → 跳） |
| n / x / o | `S` | 反向、不换窗、不 wrap |
| n / x / o | `f` / `t` / `F` / `T` | 行内跳，由 flash 增强（插件加载后） |

### 8. 函数签名钉住 treesitter-context（`lua/plugins.lua`）

无新快捷键。进入长函数后，窗口顶部最多钉 3 行真实源码（函数/类，也会钉 `if`/`for`）。
`:TSContextToggle` 开关。C/C++/Python/Lua/Swift 用上游 query；objc 用仓库内 `queries/objc/context.scm`。

### 9. 文本片段 / 引号配对（`lua/snippets.lua`）

这部分是**手写的按键逻辑**，不属于 LuaSnip 体系，而是用 `inoremap` 自己拼的：

#### 引号/括号自动配对（所有文件类型）

输入 `"` 自成 `""`、`'` 成 `''`、`{`↔`}`、`[`↔`]`、`(`↔`)`，光标停在中间。

#### 给当前词加包围（insert 模式，`<leader>` = `<space>`）

| 按键 | 文件类型 | 效果 |
|---|---|---|
| `<space>'` | 全部 | 当前词加 `'…'` |
| `<space>"` | 全部 | 当前词加 `"…"` |
| `<space>_` | markdown | 当前词加 `__…__`（粗体） |
| `<space>*` | markdown | 当前词加 `**…**`（粗体） |
| <code><space>\`</code> | markdown | 当前词加 `` `…` ``（行内代码） |

#### 行尾补 `;` 并换行（insert 模式）

| 按键 | 文件类型 | 效果 |
|---|---|---|
| `;;` | c / cpp / objc / objcpp / objective-c / objective-cpp / markdown | 行尾加 `;` + 换行 |

#### 其它文件类型快捷键（insert 模式）

| 按键 | 文件类型 | 效果 |
|---|---|---|
| `<space>pp` | c / cpp / objc / objcpp / objective-c / objective-cpp | 末尾加 `{}` 并展开成块 |
| `,,` | c / cpp / objc / objcpp / objective-c / objective-cpp / **lua** | 在右侧插入逗号 |

#### vim 文件类型的缩写（insert 模式）

| 缩写 | 展开为 |
|---|---|
| `<b` | `BufNewFile ` |
| `bnf` | `BufNewFile ` |
| `br` | `BufRead ` |
| `ft` | `FileType ` |

### 10. 格式化（`lua/config/nvim-formatter-cfg.lua`）

无快捷键，**保存即格式化**（`BufWritePre → :Format`）。

- Lua：stylua（文件名为 `special.lua` 时跳过）
- C / C++：clang-format
- JSON / JSONC：prettier
- Bash / sh：shfmt
- 所有文件：去掉行尾空白

也可手动用 `:Format` / `:FormatWrite` 命令。

---

## 四、启动行为

- 启动时打印 `>^.^< happy coding mio~`
- 状态栏：`%f-%r%m%=%y-%l/%L-0vo`（文件名 / 只读 / 修改标记 / 右对齐 / 类型 / 行号/总行/虚拟列）
- `BufNewFile *` 自动 `:write`