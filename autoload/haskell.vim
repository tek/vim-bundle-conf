let s:import_re = '^import '

function! s:find_block_end(found, current) abort "{{{
  keepjumps let end = search('\v^(import|\s)@!', 'W')
  return end > 0 ? s:find_blocks(a:found + [[a:current, end - 1]], end) : a:found + [[a:current, line('$')]]
endfunction "}}}

function! s:find_blocks(found, previous) abort "{{{
  keepjumps let next = search(s:import_re, 'W')
  return (next == 0 || next <= a:previous) ? a:found : s:find_block_end(a:found, next)
endfunction "}}}

function! haskell#import_blocks() abort "{{{
  keepjumps normal gg
  return s:find_blocks([], 1)
endfunction "}}}

function! haskell#import_statements(block, agg) abort "{{{
  if len(a:block) == 0
    return a:agg
  else
    let [next; rest] = a:block
    let next_index = match(rest, s:import_re)
    let [tail, remainder] = next_index == 0 ? [[], rest] : (
          \ next_index == -1 ? [rest, []] : [rest[:next_index - 1], rest[next_index:]]
          \ )
    let statement = { 'head': next, 'tail': tail }
    return haskell#import_statements(remainder, a:agg + [statement])
  endif
endfunction "}}}

function! s:strip_import_keywords(a) abort "{{{
  return substitute(a:a, '\v^import %(qualified )?', '', '')
endfunction "}}}

function! s:compare_imports(l, r) abort "{{{
  let l = s:strip_import_keywords(a:l.head)
  let r = s:strip_import_keywords(a:r.head)
  return l == r ? 0 : (l > r ? 1 : -1)
endfunction "}}}

function! haskell#sort_block(block) abort "{{{
  let [start, end] = a:block
  let lines = map(copy(range(start, end)), { i, l -> getline(l) })
  let imports = haskell#import_statements(lines, [])
  let sorted = sort(copy(imports), function('<sid>compare_imports'))
  return {
        \ 'start': start,
        \ 'end': end,
        \ 'modified': imports != sorted,
        \ 'data': list#fmap(sorted, { a -> [a.head] + a.tail }),
        \ }
endfunction "}}}

function! haskell#sort_imports() abort "{{{
  let view = winsaveview()
  try
    let blocks = map(copy(haskell#import_blocks()), { i, a -> haskell#sort_block(a) })
    for block in blocks
      if block.modified
        keepjumps call setline(block.start, list#concat(block.data))
      endif
    endfor
  finally
    call winrestview(view)
  endtry
  noautocmd w
endfunction "}}}
