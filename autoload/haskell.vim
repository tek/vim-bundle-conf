let s:import_start_re = '^import '
let s:import_re = '\v^(import%(\s+qualified)?\s+\S+%(%(\s+as \S+)|\s+hiding)?)\s*%((\(.*\)))?$'
let s:names_re = '\v%(\([^)]*)@<!,\s*'

function! s:find_block_end(found, current) abort "{{{
  keepjumps let end = search('\v^(import|\s)@!', 'W')
  return end > 0 ? s:find_blocks(a:found + [[a:current, end - 1]], end) : a:found + [[a:current, line('$')]]
endfunction "}}}

function! s:find_blocks(found, previous) abort "{{{
  keepjumps let next = search(s:import_start_re, 'W')
  return (next == 0 || next <= a:previous) ? a:found : s:find_block_end(a:found, next)
endfunction "}}}

function! haskell#import_blocks() abort "{{{
  keepjumps normal gg
  return s:find_blocks([], 1)
endfunction "}}}

function! s:parse_names(match) abort "{{{
  let names = substitute(a:match, '\v^\((.*)\)$', '\1', '')
  return uniq(map(split(names, s:names_re), { i, a -> trim(a) }))
endfunction "}}}

function! haskell#import_statements(block, agg) abort "{{{
  if len(a:block) == 0
    return a:agg
  else
    let [cur; rest] = a:block
    let next_index = match(rest, s:import_start_re)
    let [tail, remainder] = next_index == 0 ? [[], rest] : (
          \ next_index == -1 ? [rest, []] : [rest[:next_index - 1], rest[next_index:]]
          \ )
    let multi = len(tail) > 0
    let import = matchlist(join([cur] + tail, ' '), s:import_re)
    let head_match = get(import, 1, '')
    let head = len(head_match) > 0 ? head_match : get(import, 0, cur)
    let names_match = get(import, 2, '')
    let statement = {
          \ 'head': head,
          \ 'has_names': len(names_match) > 0,
          \ 'names': s:parse_names(names_match),
          \ 'multi': multi,
          \ }
    return haskell#import_statements(remainder, a:agg + [statement])
  endif
endfunction "}}}

function! s:strip_import_keywords(a) abort "{{{
  return substitute(a:a, '\v^import\s+%(qualified\s+)?', '', '')
endfunction "}}}

function! s:compare_names(l, r) abort "{{{
  let left_op = a:l[:0] == '('
  let right_op = a:r[:0] == '('
  return left_op ? (right_op ? a:l[1:] > a:r[1:] : 1) : (right_op ? -1 : a:l > a:r)
endfunction "}}}

function! haskell#format_single_import(head, names, has_names) abort "{{{
  let head_suf = a:has_names ? ' (' . join(a:names)[:-2] . ')' : ''
  return [a:head . head_suf]
endfunction "}}}

function! haskell#format_multi_import(head, names) abort "{{{
  let names = map(copy(a:names), { i, a -> '  ' . a})
  return [a:head . ' ('] + names + ['  )']
endfunction "}}}

function! haskell#format_import(import) abort "{{{
  let names = map(sort(copy(a:import.names), { l, r -> s:compare_names(l, r) }), { i, a -> a . ',' })
  let head = substitute(a:import.head, '\v\s+', ' ', 'g')
  return a:import.multi ?
        \ haskell#format_multi_import(head, names) :
        \ haskell#format_single_import(head, names, a:import.has_names)
endfunction "}}}

function! s:compare_imports(l, r) abort "{{{
  let l = s:strip_import_keywords(a:l.head)
  let r = s:strip_import_keywords(a:r.head)
  " return l > r
  return l == r ? 0 : (l > r ? 1 : -1)
endfunction "}}}

function! haskell#sort_block(block) abort "{{{
  let [start, end] = a:block
  let lines = map(copy(range(start, end)), { i, l -> getline(l) })
  let imports = haskell#import_statements(lines, [])
  let sorted = sort(copy(imports), { l, r -> s:compare_imports(l, r) })
  let formatted = map(copy(sorted), { i, imp -> haskell#format_import(imp) })
  let updated_lines = list#concat(formatted)
  return {
        \ 'start': start,
        \ 'end': end,
        \ 'modified': lines != updated_lines,
        \ 'data': updated_lines,
        \ }
endfunction "}}}

function! haskell#sort_imports() abort "{{{
  if bufname('%') == ''
    return
  endif
  let view = winsaveview()
  try
    let blocks = map(copy(haskell#import_blocks()), { i, a -> haskell#sort_block(a) })
    for block in blocks
      if block.modified
        keepjumps silent call setline(block.start, block.data)
      endif
    endfor
  finally
    call winrestview(view)
  endtry
  keepjumps silent noautocmd w
endfunction "}}}

function! haskell#sort_imports_save() abort "{{{
  if &ft == 'haskell' && get(g:, 'haskell_sort_imports', 1)
    return haskell#sort_imports()
  endif
endfunction "}}}
