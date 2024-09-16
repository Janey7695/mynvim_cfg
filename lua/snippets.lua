function AddSurroundx(inputchar, targetchar, isLocal)
	local template
	if isLocal == 1 then
		template = ":inoremap <leader>"
			.. inputchar
			.. " <esc>viw<esc>a"
			.. targetchar
			.. "<esc>hbi"
			.. targetchar
			.. "<esc>A"
	else
		template = ":inoremap <buffer> <leader>"
			.. inputchar
			.. " <esc>viw<esc>a"
			.. targetchar
			.. "<esc>hbi"
			.. targetchar
			.. "<esc>A"
	end
	vim.api.nvim_exec(template, true)
end

AddSurroundx("'", "'", 0)
AddSurroundx("''", '"', 0)

function Quto_Comp(inputquto, anotherside)
	local template = ":inoremap " .. inputquto .. " " .. inputquto .. anotherside .. "<esc>i"
	vim.api.nvim_exec(template, true)
	template = ":inoremap " .. inputquto .. anotherside .. " " .. inputquto .. anotherside .. "<esc>i"
	vim.api.nvim_exec(template, true)
end

Quto_Comp('"', '"')
Quto_Comp("'", "'")
Quto_Comp("{", "}")
Quto_Comp("[", "]")
Quto_Comp("(", ")")

vim.cmd([[augroup filetype_vimrc]])
vim.cmd([[autocmd!]])
vim.cmd([[autocmd FileType vim :iabbrev <buffer> <b]])
vim.cmd([[autocmd FileType vim :iabbrev <buffer> bnf BufNewFile ]])
vim.cmd([[autocmd FileType vim :iabbrev <buffer> br BufRead ]])
vim.cmd([[autocmd FileType vim :iabbrev <buffer> ft FileType ]])
vim.cmd([[augroup END]])

vim.cmd([[autocmd FileType markdown lua AddSurroundx("_","__",1)]])
vim.cmd([[autocmd FileType markdown lua AddSurroundx("*","**",1)]])
vim.cmd([[autocmd FileType markdown lua AddSurroundx("`","`",1)]])
-- vim.cmd([[autocmd FileType markdown inoremap <buffer> <leader>` ```]])
vim.cmd([[autocmd FileType markdown inoremap <buffer> ;; <esc>A;<cr>]])

vim.cmd([[autocmd FileType cpp inoremap <buffer> ;; <esc>A;<cr>]])
vim.cmd([[autocmd FileType cpp inoremap <buffer> <leader>pp <esc>A<space>{}<esc>i<cr><esc>O]])
vim.cmd([[autocmd FileType cpp inoremap <buffer> ,, <esc>la,]])

vim.cmd([[autocmd FileType lua inoremap <buffer> ,, <esc>la,]])
