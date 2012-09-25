function! tek_circumcise#tabstops_pre(pattern) "{{{
  let pattern = circumcise#bsub(a:pattern, '#{quoted_group}', '"${XXX:identifier}"')
  return pattern
endfunction "}}}
