function! haskell#marks#set() abort "{{{
  if bufname('%') == ''
    return
  endif
  try
    let view = winsaveview()
    let blocks = haskell#import_blocks()
    let [begin; rest] = get(blocks, -1, [2])
    silent! execute string(begin - 1) . 'mark i'
  finally
    call winrestview(view)
  endtry
endfunction "}}}
