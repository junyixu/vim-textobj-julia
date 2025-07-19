" Text objects for Julia
" Version 0.1.0
" Copyright (C) 2024 Julia Text Object Plugin
" License: MIT license

if exists('g:loaded_textobj_julia')
  finish
endif

if exists('*textobj#user#plugin')
  function! s:select_julia_function(type)
    if a:type == 'a'
        " 选择整个函数（包括 function 关键字和 end）
        let pattern_start = '\v^\s*(function|if|for|while|try|begin)\s+'
        let pattern_end = '\v^\s*end\s*$'
    elseif a:type == 'i'
        " 选择函数内部（不包括 function 行和 end 行）
        let pattern_start = '\v^\s*(function|if|for|while|try|begin)\s+'
        let pattern_end = '\v^\s*end\s*$'
    else
        return 0
    endif
    
    " 保存当前光标位置
    let save_pos = getpos('.')
    
    " 首先检查当前行是否是 function 行
    let current_line = getline('.')
    if current_line =~ '\v^\s*function\s+'
        let func_start = line('.')
    else
        " 如果不是，则向上搜索最近的 function（添加 'c' 标志）
        let func_start = search('\v^\s*function\s+', 'bcnW')
        if func_start == 0
            call setpos('.', save_pos)
            return 0
        endif
    endif
    
    " 从 function 位置开始，使用完整的配对搜索找到对应的 end
    call cursor(func_start, 1)
    let func_end = searchpair(pattern_start, '', pattern_end, 'W')
    if func_end == 0
        call setpos('.', save_pos)
        return 0
    endif
    
    " 恢复光标位置
    call setpos('.', save_pos)
    
    if a:type == 'i'
        " 内部选择：跳过 function 行和 end 行
        let start_line = func_start + 1
        let end_line = func_end - 1
        if start_line > end_line
            return 0
        endif
        return ['V', [0, start_line, 1, 0], [0, end_line, col([end_line, '$']), 0]]
    else
        " 外部选择：包含整个函数
        return ['V', [0, func_start, 1, 0], [0, func_end, col([func_end, '$']), 0]]
    endif
  endfunction

  " Macro text objects  
  function! s:select_julia_macro(type)
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

  " Register with vim-textobj-user using buffer-local function approach
  let b:textobj_function_select = function('s:select_julia_function')
  let b:textobj_macro_select = function('s:select_julia_macro')

  call textobj#user#plugin('julia', {
  \   'function': {
  \     'select-a': '<buffer>af',
  \     'select-i': '<buffer>if',
  \     'select-a-function': 'b:textobj_function_select',
  \     'select-i-function': 'b:textobj_function_select',
  \   },
  \   'macro': {
  \     'select-a': '<buffer>aM', 
  \     'select-i': '<buffer>iM',
  \     'select-a-function': 'b:textobj_macro_select',
  \     'select-i-function': 'b:textobj_macro_select',
  \   }
  \ })

  " Motion mappings
  nnoremap <silent> <buffer>]m :call search('^\s*function\s', 'W')<cr>
  nnoremap <silent> <buffer>[m :call search('^\s*function\s', 'bW')<cr>
  nnoremap <silent> <buffer>]M :call search('^\s*macro\s', 'W')<cr>
  nnoremap <silent> <buffer>[M :call search('^\s*macro\s', 'bW')<cr>
  
  onoremap <silent> <buffer>]m :call search('^\s*function\s', 'W')<cr>
  onoremap <silent> <buffer>[m :call search('^\s*function\s', 'bW')<cr>
  onoremap <silent> <buffer>]M :call search('^\s*macro\s', 'W')<cr>
  onoremap <silent> <buffer>[M :call search('^\s*macro\s', 'bW')<cr>

  let g:loaded_textobj_julia = 1
endif