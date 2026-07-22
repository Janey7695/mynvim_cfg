# 我的 Neovim 配置

一套偏 Python / Lua / C++ 开发的轻量 Neovim 配置，Leader 键为 **空格**，主题用 Monokai Pro。

```
~/.config/nvim/
├── init.lua                      # 入口
├── lua/
│   ├── basic_config.lua          # 基本编辑选项（缩进、行号、剪贴板、leader）
│   ├── keymaps.lua               # 通用快捷键（窗口、tab、ESC 替代）
│   ├── snippets.lua              # 手写的引号配对 / C++/Markdown / vim 缩写
│   ├── plugins.lua               # lazy.nvim 插件清单（含 blink.cmp 配置）
│   ├── lsp.lua                   # LSP：mason + vim.lsp.config/enable
│   └── config/
│       ├── nvim-tree-cfg.lua     # 文件树
│       └── nvim-formatter-cfg.lua# 保存时格式化
└── KEYBINDINGS.md                 # 完整快捷键与插件清单（详见此文件）
```

## 要求

- **Neovim ≥ 0.11**（使用了 `vim.lsp.config` / `vim.lsp.enable` 新 API）
- 一份 Nerd Font（用于文件树和补全菜单的图标）
- 联网（首次启动 lazy.nvim 和 mason 会自动克隆 / 安装）

## 安装

```bash
git clone <this-repo> ~/.config/nvim
nvim   # 首次启动会自动装好所有插件和 LSP server
```

无需任何手动操作。lazy.nvim 会拉取插件，mason 会自动安装 `pylsp`、`lua_ls`、`clangd` 三个 LSP server。

## 包含什么

- **主题**：[monokai.nvim](https://github.com/tanvirtin/monokai.nvim)
- **补全**：[blink.cmp](https://github.com/saghen/blink.cmp) v1（Rust + SIMD 模糊匹配，内置 LSP/path/snippets/buffer 源和图标）
- **片段**：[LuaSnip](https://github.com/L3MON4D3/LuaSnip) v2
- **LSP**：[mason.nvim](https://github.com/williamboman/mason.nvim) + [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) + [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)，启用 `lua_ls` / `pylsp` / `clangd`
- **格式化**：[formatter.nvim](https://github.com/mhartington/formatter.nvim)，保存时自动跑 stylua / clang-format / 去行尾空白
- **文件树**：[nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)

完整的插件列表、每个插件干什么、以及所有快捷键的对照表，见 **[KEYBINDINGS.md](./KEYBINDINGS.md)**。

## 几个常用键速查

| 按键 | 作用 |
|---|---|
| `<space>o` | 打开 / 关闭文件树 |
| `<space>ec` / `<space>sc` | 编辑配置 / 重新加载配置 |
| `<space>e` | 浮动诊断窗口 |
| `gd` / `gr` / `K` | 跳定义 / 引用 / hover |
| `<space>rn` / `<space>ca` | 重命名 / code action |
| `<space>f` | LSP 格式化 |
| `<Tab>` / `<S-Tab>` / `<CR>` | 在补全菜单中选 / 接受 |
| `jj` | insert 模式下回到 normal |

> `:Mason` 打开包管理浮窗，`:Lazy` 打开插件管理浮窗。