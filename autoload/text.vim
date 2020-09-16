function! text#indent(count, str) abort "{{{
  return repeat(' ', a:count) . a:str
endfunction "}}}
