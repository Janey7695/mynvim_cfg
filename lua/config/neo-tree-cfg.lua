-- Neo-tree 文件树配置
-- 替代旧 nvim-tree.lua，保留原有习惯（<space>o toggle、宽 30、显示 dotfiles、
-- 大小写敏感排序、空目录分组），新增 git 状态显示。

require("neo-tree").setup({
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = false,
    sort_case_insensitive = false, -- 大小写敏感排序（和旧 nvim-tree 一致）
    window = {
        position = "left",
        width = 30, -- 和旧 nvim-tree 一致
        mappings = {
            -- <CR> 打开文件，<bs> 回到父目录，? 帮助；沿用 nvim-tree 的习惯
            ["<CR>"] = "open",
            ["<bs>"] = "navigate_up",
            ["?"] = "show_help",
        },
    },
    filesystem = {
        filtered_items = {
            hide_dotfiles = false, -- 显示 dotfiles（和旧 nvim-tree 一致）
            hide_gitignored = false,
        },
        group_empty_dirs = true, -- 空目录折叠（和旧 nvim-tree renderer.group_empty 一致）
        follow_current_file = {
            enabled = true, -- 打开文件时自动跟随
            leave_dirs_open = false,
        },
    },
})

-- 切换文件树 <space>o：复用原来的 keymaps.lua 里若没改，这里设
vim.keymap.set("n", "<space>o", "<cmd>Neotree filesystem toggle<CR>", {
    noremap = true,
    silent = true,
    desc = "Toggle Neo-tree filesystem",
})