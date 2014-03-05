function! tek_yaml#senna_to_yaml() abort "{{{
  '<,'> substitute /\S\+\s\+\S\+\s\+\zs\S\+/
  '<,'> substitute /\s\+/ /g
  '<,'> substitute /^\s*/
  '<,'> substitute /\s\zs\w-\ze\S\+/ /g
  '<,'> substitute /\S\+/'&',/g
  '<,'> substitute /\(.*\),$/ - [\1]/
  normal! gvgu
  Tabularize /,\zs\s\+/
  '< put! ='-'
endfunction "}}}
