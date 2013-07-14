function! maque#ft#nose#set_makeprg() "{{{
  call maque#set_params(pyeval('tek_vim_py_test.set_makeprg_nose_function()'))
  return 1
endfunction "}}}
