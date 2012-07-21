if exists('g:loaded_acp')
  let g:acp_behaviorCppOmniMethodLength = 0
  let g:acp_behavior['cpp'] = deepcopy(g:acp_behavior['*'])

  function! Cpp_use_filename_completion(context)
    return a:context =~ '^#include <'
  endfunction

  function! Cpp_use_omni_completion(context)
    return a:context =~ printf('[^. \t]\(\.\|::\|->\)\k\{%d,}$', g:acp_behaviorCppOmniMethodLength)
  endfunction

  call add(acp_behavior.cpp, {
        \   'command' : "\<C-x>\<C-f>",
        \   'meets'   : 'Cpp_use_filename_completion',
        \   'repeat'  : 0,
        \ })

  call add(g:acp_behavior.cpp, {
        \   'command'  : "\<C-x>\<C-o>",
        \   'meets'  : 'Cpp_use_omni_completion',
        \   'repeat'   : 0,
        \ })

  call insert(acp_behavior.python, {
        \   'command' : "\<C-x>\<C-u>",
        \   'completefunc': 'tek_acp#python_user',
        \   'meets'   : 'tek_acp#meets_python_user',
        \   'repeat'  : 0,
        \ })

  let acp_behavior.python[-1].onPopupClose = 'tek_acp#on_popup_close_omni'

  let acp_behavior['cucumber'] = deepcopy(g:acp_behavior['*'])
  call insert(acp_behavior.cucumber, {
        \   'command' : "\<C-x>\<C-o>",
        \   'meets'   : 'tek_acp#meets_cucumber_omni',
        \   'repeat'  : 0,
        \ })
endif
