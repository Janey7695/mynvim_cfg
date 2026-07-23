-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- 注：formatter.nvim 自带的预置见 :h formatter.filetypes；我们手动写
-- 是为了走 mason 装的 prettier/shfmt，而不用全局 PATH 里的版本。
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- You can also define your own configuration
			function()
				-- Supports conditional formatting
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end

				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},
		python = {
			function()
				return {
					exe = "ruff",
					args = {
						"format",
						"--stdin-filename",
						util.escape_path(util.get_current_buffer_file_path()),
						"-",
					},
					stdin = true,
				}
			end,
		},
		cpp = {
			function()
				return {
					exe = "clang-format",
					args = {
						"-assume-filename",
						util.escape_path(util.get_current_buffer_file_name()),
					},
					stdin = true,
					try_node_modules = true,
				}
			end,
		},
		c = {
			function()
				return {
					exe = "clang-format",
					args = {
						"-assume-filename",
						util.escape_path(util.get_current_buffer_file_name()),
					},
					stdin = true,
					try_node_modules = true,
				}
			end,
		},
		json = {
			-- prettier 同时处理 json / jsonc；走 mason 装的 prettier
			function()
				return {
					exe = "prettier",
					args = {
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--no-config",
						"--tab-width", "4",
					},
					stdin = true,
				}
			end,
		},
		["jsonc"] = {
			function()
				return {
					exe = "prettier",
					args = {
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--no-config",
						"--tab-width", "4",
					},
					stdin = true,
				}
			end,
		},
		-- sh / bash：shfmt（默认 2 空格缩进，带 :-like POSIX 模式）
		sh = {
			function()
				return {
					exe = "shfmt",
					args = { "-i", "4", "-" },
					stdin = true,
				}
			end,
		},
		bash = {
			function()
				return {
					exe = "shfmt",
					args = { "-i", "4", "-bn", "-ci", "-" },
					stdin = true,
				}
			end,
		},
		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePre", {
	group = "__formatter__",
	callback = function()
		-- vim.cmd.Format() doesn't work reliably in headless;
		-- use the canonical string form instead
		vim.cmd([[Format]])
	end,
})
