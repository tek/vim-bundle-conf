let s:import_start_re = '^import '
let s:import_re = '\v^import\s+(\S+)\.\s*%(\{(.+)\}|(\S+))\s*$'

function! scala#imports#imports() abort "{{{
  keepjumps normal gg
  keepjumps let start = search(s:import_start_re, 'W')
  keepjumps let found_end = search('\v^(import|\s|\}|$)@!', 'W')
  let end = found_end > 1 ? found_end - 1 : line('$')
  return [start, end]
endfunction "}}}

function! s:parse_names(match) abort "{{{
  return map(split(a:match, ',\s*'), { i, a -> trim(a) })
endfunction "}}}

function! scala#imports#import_statements(block, agg) abort "{{{
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
    let names_match = get(import, 2, '') . get(import, 3, '')
    let statement = {
          \ 'head': head,
          \ 'has_names': len(names_match) > 0,
          \ 'names': s:parse_names(names_match),
          \ 'multi': multi,
          \ }
    return scala#imports#import_statements(remainder, a:agg + [statement])
  endif
endfunction "}}}

function! s:compare_names(l, r) abort "{{{
  let left_op = a:l[:0] == '('
  let right_op = a:r[:0] == '('
  return left_op ? (right_op ? a:l[1:] > a:r[1:] : 1) : (right_op ? -1 : a:l > a:r)
endfunction "}}}

function! scala#imports#format_single_import(head, names, has_names) abort "{{{
  let head_suf = a:has_names ?
        \ '.' . (len(a:names) > 1 ? '{' . join(a:names, ', ') . '}' : join(a:names)) :
        \ ''
  return ['import ' . a:head . head_suf]
endfunction "}}}

function! scala#imports#format_multi_import(head, names) abort "{{{
  let names = map(copy(a:names), { i, a -> '  ' . a})
  let with_comma = map(copy(names[:-2]), { i, a -> a . ',' }) + names[-1:]
  return ['import ' . a:head . '.{'] + with_comma + ['}']
endfunction "}}}

function! scala#imports#format_import(import) abort "{{{
  let names = sort(copy(a:import.names), { l, r -> s:compare_names(l, r) })
  let head = substitute(a:import.head, '\v\s+', ' ', 'g')
  return a:import.multi ?
        \ scala#imports#format_multi_import(head, names) :
        \ scala#imports#format_single_import(head, names, a:import.has_names)
endfunction "}}}

function! s:merge(l, r) abort "{{{
  return {
        \ 'head': a:l.head,
        \ 'has_names': a:l.has_names && a:r.has_names,
        \ 'names': a:l.names + a:r.names,
        \ 'multi': a:l.multi || a:r.multi,
        \ }
endfunction "}}}

function! s:group_import(current, rest, result) abort "{{{
  let grouped = len(a:result) > 0 && a:current.head == a:result[-1].head ?
        \ a:result[:-2] + [s:merge(a:current, a:result[-1])] :
        \ a:result + [a:current]
  return len(a:rest) > 0 ? s:group_import(a:rest[0], a:rest[1:], grouped) : grouped
endfunction "}}}

function! scala#imports#group_imports(imports) abort "{{{
  return len(a:imports) > 1 ? s:group_import(a:imports[0], a:imports[1:], []) : a:imports
endfunction "}}}

function! s:compare_imports(l, r) abort "{{{
  let l = a:l.head
  let r = a:r.head
  return l == r ? 0 : (l > r ? 1 : -1)
endfunction "}}}

function! scala#imports#sort_block(block) abort "{{{
  let sorted = scala#imports#group_imports(sort(copy(a:block), { a, b -> s:compare_imports(a, b) }))
  let formatted = map(copy(sorted), { i, imp -> scala#imports#format_import(imp) })
  return list#concat(formatted)
endfunction "}}}

function! scala#imports#remove_prefix(prefix, prefixes, imports, blocks) abort "{{{
  let Matcher = { i, imp -> match(imp.head, a:prefix) }
  let imports_rest = filter(copy(a:imports), Matcher)
  let block = filter(copy(a:imports), { i, l -> !Matcher(i, l) })
  return scala#imports#split(a:prefixes, imports_rest, a:blocks + [block])
endfunction "}}}

function! scala#imports#split(prefixes, imports, blocks) abort "{{{
  return len(a:prefixes) == 0 ?
        \ a:blocks + [a:imports] :
        \ scala#imports#remove_prefix(a:prefixes[0], a:prefixes[1:], a:imports, a:blocks)
endfunction "}}}

function! scala#imports#process_lines(prefixes, start, end) abort "{{{
  let lines = map(copy(range(a:start, a:end)), { i, l -> getline(l) })
  let nonzero_lines = filter(copy(lines), { i, a -> a !~ '^\s*$' })
  let imports = scala#imports#import_statements(nonzero_lines, [])
  let blocks = scala#imports#split(a:prefixes, imports, [])
  let sorted_blocks = map(copy(blocks), { i, b -> scala#imports#sort_block(b) + [''] })
  let sorted = list#concat(sorted_blocks)
  return { 'data': sorted, 'modified': sorted != lines }
endfunction "}}}

function! scala#imports#sort() abort "{{{
  if bufname('%') == ''
    return
  endif
  let view = winsaveview()
  try
    let prefixes = get(g:, 'scala_import_prefixes', ['^java\.', '^scala\.', '^\U'])
    let [start, end] = scala#imports#imports()
    if start > 0
      let updated = scala#imports#process_lines(prefixes, start, end)
      if updated.modified
        keepjumps silent call nvim_buf_set_lines(bufnr('%'), start - 1, end, v:false, updated.data)
      endif
      if getline(start - 1) != ''
        keepjumps silent call nvim_buf_set_lines(bufnr('%'), start - 1, start - 1, v:false, [''])
      endif
    endif
  finally
    call winrestview(view)
  endtry
  keepjumps silent noautocmd w
endfunction "}}}

function! scala#imports#sort_save() abort "{{{
  if &ft == 'scala' && get(g:, 'scala_sort_imports', 1)
    return scala#imports#sort()
  endif
endfunction "}}}
