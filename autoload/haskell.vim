function! s:find_block_end(found, current) abort "{{{
  keepjumps let end = search('\v^(import)@!', 'W')
  return end > 0 ? s:find_blocks(a:found + [[a:current, end - 1]], end) : a:found + [[a:current, line('$')]]
endfunction "}}}

function! s:find_blocks(found, previous) abort "{{{
  keepjumps let next = search('^import ', 'W')
  return (next == 0 || next <= a:previous) ? a:found : s:find_block_end(a:found, next)
endfunction "}}}

function! haskell#import_blocks() abort "{{{
  keepjumps normal gg
  return s:find_blocks([], 1)
endfunction "}}}

function! haskell#sort_imports() abort "{{{
  let view = winsaveview()
  try
    for [start, end] in haskell#import_blocks()
      keepjumps execute start . ',' end . 'sort /\v^import\s*(qualified\s*)?/'
    endfor
  finally
    call winrestview(view)
  endtry
  noautocmd w
endfunction "}}}
