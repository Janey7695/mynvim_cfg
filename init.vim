" --- Basic Settings ---
:syntax on
:set mouse=a
:set relativenumber numberwidth=3
:set autoindent
:set shiftwidth=4
:set softtabstop=4
:echo ">^.^< happy coding mio~"

" --- Some Iabbrev --- 
:iabbrev @@ jyxu7695@163.com

" --- Mappings ---
:let mapleader = "\<space>"
:inoremap jj <esc>
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>
:inoremap <leader>u <esc>viwU

" 在输入模式下，为目标单词围绕字符
:function! AddSurroundx(inputchar,targetchar,isLocal)
:if a:isLocal
:let template = ":inoremap \<leader>" . a:inputchar . " \<esc>viw\<esc>a" . a:targetchar . "\<esc>hbi" . a:targetchar . "\<esc>A"
:execute template
:else
:let template = ":inoremap \<buffer> \<leader>" . a:inputchar . " \<esc>viw\<esc>a" . a:targetchar . "\<esc>hbi" . a:targetchar . "\<esc>A"
:execute template
:endif
:endfunction

:call AddSurroundx("\'","\'",0)
:call AddSurroundx("\'\'","\"",0)

:autocmd BufNewFile * :write

" --- Status Line ---
:set statusline=%f-%r%m%=%y-%l/%L-0vo

" --- snippet ---
" - genernal -
"   括号补全
:function! Quto_Comp(inputquto,anotherside)
:let template = ":inoremap " . a:inputquto . " " . a:inputquto . a:anotherside . "\<esc>i"
:execute template
:let template = ":inoremap " . a:inputquto . a:anotherside . " " . a:inputquto . a:anotherside . "\<esc>i"
:execute template
:endfunction

:call Quto_Comp("\"","\"")
:call Quto_Comp("\'","\'")
:call Quto_Comp("{","}")
:call Quto_Comp("[","]")
:call Quto_Comp("(",")")

" - vimrc -
:augroup filetype_vimrc
:autocmd!
:autocmd FileType vim :iabbrev <buffer> <b <buffer> <left>
:autocmd FileType vim :iabbrev <buffer> bnf BufNewFile <left>
:autocmd FileType vim :iabbrev <buffer> br BufRead <left>
:autocmd FileType vim :iabbrev <buffer> ft FileType <left> 
:augroup END
" - markdown -
:autocmd FileType markdown :call AddSurroundx("_","__",1)
:autocmd FileType markdown :call AddSurroundx("*","**",1)
:autocmd FileType markdown :call AddSurroundx("`","`",1)
" :autocmd FileType markdown :inoremap <buffer> <leader>` ```
:autocmd FileType markdown :inoremap <buffer> ;; <esc>A;<enter>

" - c/cpp -

:autocmd FileType cpp :inoremap <buffer> ;; <esc>A;<enter>
:autocmd FileType cpp :inoremap <buffer> <leader>pp <esc>A<space>{}<esc>i<enter><esc>O
:autocmd FileType cpp :inoremap <buffer> ,, <esc>la,
