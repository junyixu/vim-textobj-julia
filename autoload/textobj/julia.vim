" Text objects for Julia
" Version 0.1.0
" Provides text objects and motions for Julia functions and macros
" This file contains the core autoload functions - exact copy from original implementation

" Select Julia function text object - original implementation
" type: 'a' for entire function, 'i' for inner function body
function! textobj#julia#function_select(type)
    if a:type == 'a'
        let pattern_start = '\v^\s*(function|if|for|while|try|begin)\s+'
        let pattern_end = '\v^\s*end\s*$'
    elseif a:type == 'i'
        let pattern_start = '\v^\s*(function|if|for|while|try|begin)\s+'
        let pattern_end = '\v^\s*end\s*$'
    else
        return 0
    endif
    
    let save_pos = getpos('.')
    
    " First check if current line is function line
    let current_line = getline('.')
    if current_line =~ '\v^\s*function\s+'
        let func_start = line('.')
    else
        let func_start = search('\v^\s*function\s+', 'bcnW')
        if func_start == 0
            call setpos('.', save_pos)
            return 0
        endif
    endif
    
    call cursor(func_start, 1)
    let func_end = searchpair(pattern_start, '', pattern_end, 'W')
    if func_end == 0
        call setpos('.', save_pos)
        return 0
    endif
    
    call setpos('.', save_pos)
    
    if a:type == 'i'
        let start_line = func_start + 1
        let end_line = func_end - 1
        if start_line > end_line
            return 0
        endif
        return ['V', [0, start_line, 1, 0], [0, end_line, col([end_line, '$']), 0]]
    else
        return ['V', [0, func_start, 1, 0], [0, func_end, col([func_end, '$']), 0]]
    endif
endfunction

" Select Julia macro text object - original implementation
" type: 'a' for entire macro, 'i' for inner macro body
function! textobj#julia#macro_select(type)
    if a:type == 'a'
        let pattern_start = '\v^\s*(macro|if|for|while|try|begin)\s+'
        let pattern_end = '\v^\s*end\s*$'
    elseif a:type == 'i'
        let pattern_start = '\v^\s*(macro|if|for|while|try|begin)\s+'
        let pattern_end = '\v^\s*end\s*$'
    else
        return 0
    endif
    
    let save_pos = getpos('.')
    
    let current_line = getline('.')
    if current_line =~ '\v^\s*macro\s+'
        let macro_start = line('.')
    else
        let macro_start = search('\v^\s*macro\s+', 'bcnW')
        if macro_start == 0
            call setpos('.', save_pos)
            return 0
        endif
    endif
    
    call cursor(macro_start, 1)
    let macro_end = searchpair(pattern_start, '', pattern_end, 'W')
    if macro_end == 0
        call setpos('.', save_pos)
        return 0
    endif
    
    call setpos('.', save_pos)
    
    if a:type == 'i'
        let start_line = macro_start + 1
        let end_line = macro_end - 1
        if start_line > end_line
            return 0
        endif
        return ['V', [0, start_line, 1, 0], [0, end_line, col([end_line, '$']), 0]]
    else
        return ['V', [0, macro_start, 1, 0], [0, macro_end, col([macro_end, '$']), 0]]
    endif
endfunction

" Jump to matching end for current function - original implementation
function! textobj#julia#jump_to_function_end()
    let save_pos = getpos('.')
    
    let func_start = search('^\s*function\s', 'bcnW')
    if func_start == 0
        call setpos('.', save_pos)
        return
    endif
    
    call cursor(func_start, 1)
    let func_end = searchpair('\v^\s*function\s+', '', '\v^\s*end\s*$', 'W')
    if func_end == 0
        call setpos('.', save_pos)
        return
    endif
    
    call cursor(func_end, 1)
endfunction

" Jump to matching function start for current end - original implementation
function! textobj#julia#jump_to_function_start()
    let save_pos = getpos('.')
    
    let current_line = line('.')
    
    let end_line = search('^\s*end\s*$', 'bcnW')
    if end_line == 0
        call setpos('.', save_pos)
        return
    endif
    
    call cursor(end_line, 1)
    let func_start = searchpair('\v^\s*function\s+', '', '\v^\s*end\s*$', 'bW')
    if func_start == 0
        call setpos('.', save_pos)
        return
    endif
    
    call cursor(func_start, 1)
endfunction

" Jump to next/previous Julia function - original implementation
function! textobj#julia#next_function()
    call search('^\s*function\s', 'W')
endfunction

function! textobj#julia#previous_function()
    call search('^\s*function\s', 'bW')
endfunction

" Jump to next/previous Julia macro - original implementation
function! textobj#julia#next_macro()
    call search('^\s*macro\s', 'W')
endfunction

function! textobj#julia#previous_macro()
    call search('^\s*macro\s', 'bW')
endfunction