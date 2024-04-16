if exists('g:loaded_commentout')
    finish
endif
let g:loaded_commentout = 1

command! -range ToggleComment <line1>,<line2>call commentout#ToggleComment()
command! -range DupLines <line1>,<line2>call commentout#DupLines()

nnoremap <Plug>(commentout-toggle) :call commentout#ToggleComment()<CR>
vnoremap <Plug>(commentout-toggle) :call commentout#ToggleComment()<CR>
nnoremap <Plug>(commentout-dup) :call commentout#DupLines()<CR>
vnoremap <Plug>(commentout-dup) :call commentout#DupLines()<CR>
