function! haskell#buffer#rename() abort "{{{
  keepjumps silent let module_line = search('^module', 'cn')
  if module_line == -1
    return 0
  endif
  let module = matchlist(getline(module_line), '\v^module %(\k+\.)*(\k+)%([ (]|$)')
  echom string(module)
  if empty(module[1])
    return 0
  endif
  execute 'Rename ' . module[1] . '.hs'
endfunction "}}}
