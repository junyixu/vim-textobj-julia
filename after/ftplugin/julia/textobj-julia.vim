" Text objects for Julia
" Version 0.1.0
" Copyright (C) 2024 Julia Text Object Plugin
" License: MIT license

if exists('b:loaded_textobj_julia')
  finish
endif

if exists('*textobj#user#plugin')
  function! s:select_julia_function(type)
    return textobj#julia#function_select(a:type)
  endfunction

  " Macro text objects  
  function! s:select_julia_macro(type)
    return textobj#julia#macro_select(a:type)
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


  " Function to jump to matching end for current function
  function! s:jump_to_function_end()
    call textobj#julia#jump_to_function_end()
  endfunction

  " Function to jump to matching function start for current end
  function! s:jump_to_function_start()
    call textobj#julia#jump_to_function_start()
  endfunction

  " Updated motion mappings to use proper pairing
  nnoremap <silent> <buffer>]m :call search('^\s*function\s', 'W')<cr>
  nnoremap <silent> <buffer>[m :call search('^\s*function\s', 'bW')<cr>
  nnoremap <silent> <buffer>]M :call <SID>jump_to_function_end()<cr>
  nnoremap <silent> <buffer>[M :call <SID>jump_to_function_start()<cr>
  
  onoremap <silent> <buffer>]m :call search('^\s*function\s', 'W')<cr>
  onoremap <silent> <buffer>[m :call search('^\s*function\s', 'bW')<cr>
  onoremap <silent> <buffer>]M :call <SID>jump_to_function_end()<cr>
  onoremap <silent> <buffer>[M :call <SID>jump_to_function_start()<cr>

  let b:loaded_textobj_julia = 1
endif