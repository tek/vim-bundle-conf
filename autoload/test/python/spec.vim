function! test#python#spec#test_file(file) abort "{{{
  return a:file =~ '.*_spec.py'
endfunction "}}}

python3 << EOP
def build_pos():
  try:
    import tek_vim_py_test
    return [tek_vim_py_test.set_makeprg_nose_function()]
  except Exception as e:
    vim.command('echoerr "{}"'.format(e))
    return []
EOP

function! test#python#spec#build_position(type, position) abort "{{{
  return py3eval('build_pos()')
endfunction "}}}

function! test#python#spec#build_args(args) abort "{{{
  echom a:args
  return a:args
endfunction "}}}

function! test#python#spec#executable() abort "{{{
  return 'spec'
endfunction "}}}
