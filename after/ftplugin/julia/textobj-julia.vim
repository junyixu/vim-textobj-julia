" Text objects for Julia
" Version 0.1.0
" Copyright (C) 2024 Julia Text Object Plugin
" License: MIT license

" Integration with vim-textobj-user
if !exists('b:textobj_function_select')
  let b:textobj_function_select = function('textobj#julia#function_select')

  if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= '|'
  else
    let b:undo_ftplugin = ''
  endif
  let b:undo_ftplugin .= 'unlet b:textobj_function_select'
endif

if exists('g:loaded_textobj_julia')
  finish
endif

" Register with vim-textobj-user
if exists('*textobj#user#plugin')
  call textobj#user#plugin('julia', {
  \   'function': {
  \       'sfile': expand('<sfile>:p'),
  \       'select-a': '<buffer>af',
  \       'select-i': '<buffer>if',
  \       'select-a-function': 'textobj#julia#function_select_a',
  \       'select-i-function': 'textobj#julia#function_select_i',
  \       'pattern': '^\s*\zs\(function\|macro\)\s\(.\|\n\)\{-}end',
  \       'move-n': '<buffer>]m',
  \       'move-p': '<buffer>[m',
  \   },
  \   'macro': {
  \       'sfile': expand('<sfile>:p'),
  \       'select-a': '<buffer>aM',
  \       'select-i': '<buffer>iM',
  \       'select-a-function': 'textobj#julia#macro_select_a',
  \       'select-i-function': 'textobj#julia#macro_select_i',
  \       'pattern': '^\s*\zsmacro\s\(.\|\n\)\{-}end',
  \       'move-n': '<buffer>]M',
  \       'move-p': '<buffer>[M',
  \   }
  \ })

  " Additional motion mappings for Julia-specific constructs
  nnoremap <buffer>]m :call search('^\s*function\s', 'W')<cr>
  nnoremap <buffer>[m :call search('^\s*function\s', 'bW')<cr>
  nnoremap <buffer>]M :call search('^\s*macro\s', 'W')<cr>
  nnoremap <buffer>[M :call search('^\s*macro\s', 'bW')<cr>
  
  " Operator-pending mappings
  onoremap <buffer>]m :call search('^\s*function\s', 'W')<cr>
  onoremap <buffer>[m :call search('^\s*function\s', 'bW')<cr>
  onoremap <buffer>]M :call search('^\s*macro\s', 'W')<cr>
  onoremap <buffer>[M :call search('^\s*macro\s', 'bW')<cr>

  let g:loaded_textobj_julia = 1
endif