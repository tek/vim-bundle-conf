function! s:icr() abort "{{{
  let co = complete_info(['pum_visible', 'selected'])
  return co.pum_visible ?
        \ (co.selected == -1 ? "\<c-n>\<c-y>" : "\<c-y>") :
        \ "\<plug>delimitMateCR"
endfunction "}}}

imap <expr><silent> <cr> <sid>icr()
