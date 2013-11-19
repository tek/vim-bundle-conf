python3 import tek_populate, tek_vim_py_inspect
echohl WarningMsg
echo 'DEPRECATION WARNING: '.expand('%')
echohl None

function! tek_populate#python_user(findstart, base) "{{{
  python3 << END
findstart = int(vim.eval("a:findstart"))
base = vim.eval("a:base")
vim.command('return {}'.format(tek_populate.user_completion(findstart, base)))
END
endfunction "}}}

function! tek_populate#meets_python_user(context) "{{{
  python3 << END
meets = tek_populate.meets_completion(vim.eval('a:context'))
vim.command('return {}'.format(int(meets)))
END
endfunction "}}}

function! tek_populate#meets_vim_omni(context) "{{{
  return a:context =~ '\(^\s*\(au\(tocmd\)\?\|call\?\|let\|set\) \|if has(\)$'
endfunction "}}}

function! tek_populate#meets_python_omni(context) "{{{
  return a:context =~ '\%(\k\|\.\)$'
endfunction "}}}

function! tek_populate#on_popup_close_omni() "{{{
  pclose
  return 1
endfunction "}}}

function! tek_populate#meets_tex_omni(context) "{{{
  return a:context =~ '.*\([^\\]\|^\)\\\(\k*\|begin\_\s*{\k*\)$'
endfunction "}}}
