if exists('g:populate_actions')
  let g:populate_actionsCppOmniMethodLength = 0
  let g:populate_actions['cpp'] = deepcopy(g:populate_actions['*'])

  function! Cpp_use_filename_completion(context)
    return a:context =~ '^#include <'
  endfunction

  function! Cpp_use_omni_completion(context)
    return a:context =~ printf('[^. \t]\(\.\|::\|->\)\k\{%d,}$', g:populate_actionsCppOmniMethodLength)
  endfunction

  call add(g:populate_actions.cpp, {
        \   'command' : "\<C-x>\<C-f>",
        \   'meets'   : 'Cpp_use_filename_completion',
        \   'repeat'  : 0,
        \ })

  call add(g:populate_actions.cpp, {
        \   'command'  : "\<C-x>\<C-o>",
        \   'meets'  : 'Cpp_use_omni_completion',
        \   'repeat'   : 0,
        \ })

  call insert(g:populate_actions.python, {
        \   'command' : "\<C-x>\<C-u>",
        \   'completefunc': 'tek_populate#python_user',
        \   'meets'   : 'tek_populate#meets_python_user',
        \   'repeat'  : 0,
        \   'on_popup_close': 'tek_populate#on_popup_close_omni'
        \ })

  let g:populate_actions.python[1].on_popup_close = 'tek_populate#on_popup_close_omni'
  " let g:populate_actions.python[1].meets = 'tek_populate#meets_python_omni'

  let g:populate_actions['vim'] = deepcopy(g:populate_actions['*'])
  call insert(g:populate_actions.vim, {
        \   'command' : "\<C-x>\<C-o>",
        \   'meets'   : 'tek_populate#meets_vim_omni',
        \   'repeat'  : 0,
        \ })
endif
