" Text objects for Julia
" Version 0.1.0
" Provides text objects and motions for Julia functions and macros

function! textobj#julia#move_cursor_to_starting_line()
    " Start at a nonblank line
    let l:cur_pos = getpos('.')
    let l:cur_line = getline('.')
    if l:cur_line =~# '^\s*$'
        call cursor(prevnonblank(l:cur_pos[1]), 0)
    endif
endfunction

function! textobj#julia#find_defn_line(kwd)
    let l:cur_pos = getpos('.')
    let l:cur_line = getline('.')
    
    if l:cur_line =~# '^\s*'.a:kwd.'\s'
        let l:defn_pos = l:cur_pos
    else
        let l:cur_indent = indent(l:cur_pos[1])
        while 1
            if search('^\s*'.a:kwd.'\s', 'bW')
                let l:defn_pos = getpos('.')
                let l:defn_indent = indent(l:defn_pos[1])
                if l:defn_indent >= l:cur_indent
                    " This is a defn at the same level or deeper, keep searching
                    continue
                else
                    " Found a defn, make sure there aren't any statements at a
                    " shallower indent level in between
                    for l:l in range(l:defn_pos[1] + 1, l:cur_pos[1])
                        if getline(l:l) !~# '^\s*$' && indent(l:l) <= l:defn_indent
                            throw "defn-not-found"
                        endif
                    endfor
                    break
                endif
            else
                " We didn't find a suitable defn
                throw "defn-not-found"
            endif
        endwhile
    endif
    call cursor(defn_pos)
    return l:defn_pos
endfunction

function! textobj#julia#find_next_defn(kwd)
    call textobj#julia#move_cursor_to_starting_line()
    let l:cur_pos = getpos('.')
    let l:cur_indent = indent(l:cur_pos[1])
    
    " Start searching from next line
    call cursor(l:cur_pos[1] + 1, 1)
    
    while search('^\s*'.a:kwd.'\s', 'W')
        let l:found_pos = getpos('.')
        let l:found_indent = indent(l:found_pos[1])
        
        " Check if this is a valid definition (not nested deeper)
        if l:found_indent <= l:cur_indent
            return l:found_pos
        endif
        
        " Continue searching from next line
        call cursor(l:found_pos[1] + 1, 1)
    endwhile
    
    throw "defn-not-found"
endfunction

function! textobj#julia#find_prev_defn(kwd)
    call textobj#julia#move_cursor_to_starting_line()
    let l:cur_pos = getpos('.')
    let l:cur_indent = indent(l:cur_pos[1])
    
    " Start searching from previous line
    call cursor(l:cur_pos[1] - 1, 1)
    
    while search('^\s*'.a:kwd.'\s', 'bW')
        let l:found_pos = getpos('.')
        let l:found_indent = indent(l:found_pos[1])
        
        " Check if this is a valid definition
        if l:found_indent <= l:cur_indent
            return l:found_pos
        endif
        
        " Continue searching backwards
        call cursor(l:found_pos[1] - 1, 1)
    endwhile
    
    throw "defn-not-found"
endfunction

function! textobj#julia#function_select_a()
    return s:find_defn('function')
endfunction

function! textobj#julia#function_select_i()
    return s:find_defn_inner('function')
endfunction

function! textobj#julia#macro_select_a()
    return s:find_defn('macro')
endfunction

function! textobj#julia#macro_select_i()
    return s:find_defn_inner('macro')
endfunction

function! s:find_defn(kwd)
    call textobj#julia#move_cursor_to_starting_line()
    
    try
        let l:defn_pos = textobj#julia#find_defn_line(a:kwd)
    catch /defn-not-found/
        return 0
    endtry
    
    let l:defn_indent_level = indent(l:defn_pos[1])
    let l:end_pos = s:find_last_line(a:kwd, l:defn_pos, l:defn_indent_level)
    
    return ['V', l:defn_pos, l:end_pos]
endfunction

function! s:find_defn_inner(kwd)
    let l:a_pos = s:find_defn(a:kwd)
    if type(l:a_pos) == type([])
        if l:a_pos[1][1] == l:a_pos[2][1]
            " One-liner, return full selection
            return l:a_pos
        endif
        
        " Start from beginning of next line after function signature
        call cursor(l:a_pos[1][1], l:a_pos[1][2])
        normal! j0
        let l:start_pos = getpos('.')
        return ['V', l:start_pos, l:a_pos[2]]
    endif
    return 0
endfunction

function! s:find_last_line(kwd, defn_pos, indent_level)
    let l:cur_pos = getpos('.')
    let l:end_pos = l:cur_pos
    
    while 1
        " Check for one-liner: function foo() = ...
        if getline('.') =~# '^\s*'.a:kwd.'\s\+[^=]*=\s*[^#]'
            return a:defn_pos
        endif
        
        " Skip the definition line
        if line('.') == a:defn_pos[1]
            normal! j
            continue
        endif
        
        if getline('.') !~# '^\s*$'
            if indent('.') > a:indent_level
                let l:end_pos = getpos('.')
            else
                break
            endif
        endif
        
        if line('.') == line('$')
            break
        else
            normal! j
        endif
    endwhile
    
    call cursor(l:cur_pos[1], l:cur_pos[2])
    return l:end_pos
endfunction