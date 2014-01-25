function! maque#ft#spec#set_makeprg() "{{{
  python3 << EOP
try:
  import tek_vim_py_test
  params = tek_vim_py_test.set_makeprg_nose_function()
  vim.command("call maque#set_params('{}')".format(params))
except Exception as e:
  vim.command('call maque#util#warn("{}")'.format(e))
EOP
  return 1
endfunction "}}}

function! maque#ft#spec#set_makeprg_class() "{{{
  python3 << EOP
try:
  import tek_vim_py_test
  params = tek_vim_py_test.set_makeprg_nose_class()
  vim.command("call maque#set_params('{}')".format(params))
except Exception as e:
  vim.command('call maque#util#warn("{}")'.format(e))
EOP
  return 1
endfunction "}}}
