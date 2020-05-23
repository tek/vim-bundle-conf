let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''

function! SplitjoinSplitWrap() abort "{{{
  let g:uracil_skip_yank = v:true
  SplitjoinSplit
endfunction "}}}

nnoremap <silent> <leader><c-j> :call SplitjoinSplitWrap()<cr>
nnoremap <silent> gJ :call SplitjoinSplitWrap()<cr>
nnoremap <silent> <leader><c-k> :SplitjoinJoin<cr>
