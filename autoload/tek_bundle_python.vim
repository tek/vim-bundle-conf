function! tek_bundle_python#reference() "{{{
  let query = tek_python#cursor_object_for_ref()
  if len(query)
    exe 'Ref pydoc '.query
  else
    call ref#K('normal')
  endif
  exe 'resize '.(line('w$')-line('w0')+1)
endfunction "}}}
