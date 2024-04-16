function! s:get_comment_str() abort
    if  &filetype == 'vim'
        return "\""
    elseif &filetype == 'cpp'
                \ || &ft == 'java'
                \ || &ft == 'javascript'
                \ || &ft == 'php'
        return "//"
    elseif &filetype == 'bash'
                \ || &ft == 'sh'
                \ || &ft == 'python'
                \ || &ft == 'perl'
                \ || &ft == 'ruby'
                \ || &ft == 'R'
        return "#"
    elseif &filetype == 'lisp'
        return ";"
    endif
    return ''
endfunction

function! s:add_comment_str(start, end) abort
    let l:style = s:get_comment_str()
    if g:commentout_type == 0
        let l:position = 0
    elseif g:commentout_type == 1
        let l:position = 999
        for i in range(a:start, a:end)
            let l:line = getline(i)
            let l:p = (l:line =~ '^$' ? 999 : match(l:line, '\S'))
            let l:position = (l:position > l:p ? l:p : l:position)
        endfor
    endif

    for i in range(a:start, a:end)
        let l:line = getline(i)
        let l:spacer = (g:commentout_type != 0 || l:position == 0 ? ' ' : '')
        if g:commentout_type == 2
            let l:position = (l:line =~ '^$' ? 0 : match(l:line, '\S'))
        endif

        if l:position == 0
            call setline(i, l:style.l:spacer.l:line)
        else
            let l:line = (l:line == '' ? repeat(' ', l:position+1) : l:line)
            let l:left = l:line[0:l:position-1]
            let l:right = l:line[l:position:]
            call setline(i, l:left.l:style.l:spacer.l:right)
        endif
    endfor
endfunction

function! s:remove_comment_str(start, end) abort
    let l:style = s:get_comment_str()
    if g:commentout_type == 0
        if getline(a:start) =~ '^'.l:style.' \S'
            exec a:start.','.a:end."s/^".l:style." //e"
        else
            exec a:start.','.a:end."s/^".l:style."//e"
        endif
    elseif g:commentout_type == 1 || g:commentout_type == 2
        exec a:start.','.a:end.'s/^\(\s*\)'.l:style.'\s\?\(.*$\)/\1\2/e'
    endif
    exec a:start.','.a:end.'s/^\s*$//e'
endfunction

function! commentout#ToggleComment() abort range
    let g:commentout_type = get(g:, 'commentout_type', '1')
    if g:commentout_type > 2
        let g:commentout_type = 1
    endif
    let l:start = a:firstline
    let l:end = a:lastline

    let l:style = s:get_comment_str()
    if l:style == ''
        echo 'not supported'
    elseif getline(l:start) =~ '^\s*'.l:style
        exec s:remove_comment_str(l:start, l:end)
    else
        exec s:add_comment_str(l:start, l:end)
    endif
    call cursor(l:end, 0)
endfunction

function! commentout#DupLines() abort range
    let l:start = a:firstline
    let l:end = a:lastline
    let l:mode = (l:start == l:end ? 'single' : 'multi')

    if l:mode == 'single'
        silent normal! "zyy
    elseif l:mode == 'multi'
        silent normal! gv"zy
    endif

    let l:selected_num = l:end - l:start + 1
    let l:paste_start = l:end
    let l:paste_end = l:paste_start + l:selected_num

    exec s:add_comment_str(start, end)
    call cursor(l:paste_start, 0)
    normal "zp

    " Append a blank line before an original block
    if l:mode == 'multi' && getline(l:start-1) !~ "^$"
        call append(l:start-1, '')
        let l:start += 1
        let l:end += 1
        let l:paste_start += 1
        let l:paste_end += 1
    endif

    " Append a blank line between an original block and a new block
    if l:mode == 'multi'
        call append(l:end, '')
        let l:paste_start += 1
        let l:paste_end += 1
    endif

    " Append a blank line after a new block
    if l:mode == 'multi' && getline(l:paste_end + 1) !~ "^$"
        call append(l:paste_end, '')
    endif

    " Move a Cursor to begining of a new block
    call cursor(l:paste_start + 1, 0)
endfunction

