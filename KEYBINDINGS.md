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
| [`nvim-tree/nvim-tree.lua`](https://github.com/nvim-tree/nvim-tree.lua) | 文件树侧栏 |
| [`nvim-tree/nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons) | 文件类型图标 |

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

> 注意：`.m` / `.mm` 文件类型被 `vim.filetype.add` 映射为 `objective-c` / `objective-cpp`以满足 sourcekit-lsp 的要求（见 known issue #3264）。

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

### 5. 文件树 nvim-tree（`lua/config/nvim-tree-cfg.lua`）

| 按键 | 模式 | 动作 |
|---|---|---|
| `<space>o` | normal | `:NvimTreeToggle` 打开/关闭文件树 |
| `<CR>` | 文件树内 | tab_drop 打开（在当前 tab 内替换） |
| `<C-t>` | 文件树内 | 把父目录设为 root |
| `?` | 文件树内 | 切换帮助说明 |

设置：宽 30 列、大小写敏感排序、隐藏 dotfiles、新建文件会自动 `tabnew` 打开。

### 6. 文本片段 / 引号配对（`lua/snippets.lua`）

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

### 7. 格式化（`lua/config/nvim-formatter-cfg.lua`）

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