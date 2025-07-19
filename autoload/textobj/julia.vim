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
    return s:find_defn_new('function', 'a')
endfunction

function! textobj#julia#function_select_i()
    return s:find_defn_new('function', 'i')
endfunction

function! s:find_defn_new(kwd, type)
    let pattern_start = '\v^\s*' . a:kwd . '\s+'
    let pattern_end = '\v^\s*end\s*$'
    
    let save_pos = getpos('.')
    
    let current_line = getline('.')
    let kwd_pattern = '\v^\s*' . a:kwd . '\s+'
    if current_line =~ kwd_pattern
        let block_start = line('.')
    else
        let block_start = search(kwd_pattern, 'bcnW')
        if block_start == 0
            call setpos('.', save_pos)
            return 0
        endif
    endif
    
    call cursor(block_start, 1)
    let block_end = searchpair(pattern_start, '', pattern_end, 'W')
    if block_end == 0
        call setpos('.', save_pos)
        return 0
    endif
    
    call setpos('.', save_pos)
    
    if a:type == 'i'
        let start_line = block_start + 1
        let end_line = block_end - 1
        if start_line > end_line
            return 0
        endif
        return ['V', [0, start_line, 1, 0], [0, end_line, col([end_line, '$']), 0]]
    else
        return ['V', [0, block_start, 1, 0], [0, block_end, col([block_end, '$']), 0]]
    endif
endfunction

function! textobj#julia#macro_select_a()
    return s:find_defn_new('macro', 'a')
endfunction

function! textobj#julia#macro_select_i()
    return s:find_defn_new('macro', 'i')
endfunction

