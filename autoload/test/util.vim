function! test#util#want(lang, name) abort "{{{
  return !exists('g:test#python#runner') || g:test#{a:lang}#runner == a:name
endfunction "}}}
