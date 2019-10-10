let g:lexima_no_default_rules = 1
call lexima#set_default_rules()

function! s:icr() abort "{{{
  let co = complete_info(['pum_visible', 'selected'])
  return co.pum_visible ?
        \ (co.selected == -1 ? "\<c-n>\<c-y>" : "\<c-y>") :
        \ lexima#expand('<cr>', 'i')
endfunction "}}}

inoremap <expr><silent> <cr> <sid>icr()
inoremap <m-n> <c-r>=lexima#insmode#leave(1, '')<cr>
