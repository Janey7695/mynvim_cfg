-- Neo-tree 文件树配置
-- 替代旧 nvim-tree.lua，保留原有习惯（<space>o toggle、宽 30、显示 dotfiles、
-- 大小写敏感排序、空目录分组），新增 git 状态显示。

local neotree = require("neo-tree")

neotree.setup({
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = false,
    sort_case_insensitive = false, -- 大小写敏感排序（和旧 nvim-tree 一致）
    window = {
        position = "left",
        width = 30, -- 和旧 nvim-tree 一致
        mappings = {
            -- <CR> 在新标签页打开文件（像 VSCode tab 一样不覆盖当前编辑）
            ["<CR>"] = "open_tabnew",
            ["<bs>"] = "navigate_up",
            ["?"] = "show_help",
            -- a 创建文件/目录，自动刷新并打开文件（避免 :w 提示未命名文件）
            ["a"] = function(state)
                local tree = state.tree
                local node = tree:get_node()
                while node and node.type ~= "directory" do
                    local pid = node:get_parent_id()
                    if not pid then break end
                    node = tree:get_node(pid)
                end
                if not node then return end
                local dir = node:get_id()
                local inputs = require("neo-tree.ui.inputs")
                inputs.input("New name (dir ends with /):",
                    vim.fn.fnamemodify(dir .. "/", ":~"),
                    function(input)
                        if not input or input == "" then return end
                        local full = vim.fn.fnamemodify(input, ":p")
                        local is_dir = full:sub(-1) == "/"
                        if is_dir then
                            vim.fn.mkdir(full, "p")
                        else
                            vim.fn.mkdir(vim.fn.fnamemodify(full, ":h"), "p")
                            local f = io.open(full, "w")
                            if f then f:close() end
                        end
                        vim.schedule(function()
                            state.commands.refresh(state)
                            if not is_dir then
                                vim.cmd("tabnew " .. vim.fn.fnameescape(full))
                            end
                        end)
                    end)
            end,
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