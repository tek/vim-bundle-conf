let s:import_start_re = '^import '
let s:import_prefix_re = '\vimport%(\s+qualified)?%(\s+"[^"]+")?'
let s:import_re = '\v^(' . s:import_prefix_re . '\s+\S+%(%(\s+as \S+)|\s+hiding)?)\s*%((\(.*\)))?$'
let s:names_re = '\v%(\([^)]*)@<!,\s*'

function! s:find_block_end(found, current) abort "{{{
  keepjumps let end = search('\v^(import|\s)@!', 'W')
  return end > 0 ? s:find_blocks(a:found + [[a:current, end - 1]], end) : a:found + [[a:current, line('$')]]
endfunction "}}}

function! s:find_blocks(found, previous) abort "{{{
  keepjumps let next = search(s:import_start_re, 'W')
  return (next == 0 || next <= a:previous) ? a:found : s:find_block_end(a:found, next)
endfunction "}}}

function! haskell#imports#import_blocks() abort "{{{
  keepjumps normal gg
  return s:find_blocks([], 1)
endfunction "}}}

function! s:compare_names(l, r) abort "{{{
  let left_op = a:l[:0] == '('
  let right_op = a:r[:0] == '('
  return left_op ? (right_op ? a:l[1:] > a:r[1:] : 1) : (right_op ? -1 : a:l > a:r)
endfunction "}}}

function! s:sort(names) abort "{{{
  return uniq(sort(copy(a:names), { l, r -> s:compare_names(l, r) }))
endfunction "}}}

function! s:parse_names(match) abort "{{{
  let names = substitute(a:match, '\v^\((.*)\)$', '\1', '')
  return s:sort(map(split(names, s:names_re), { i, a -> trim(a) }))
endfunction "}}}

function! haskell#imports#import_statements(block, agg) abort "{{{
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
    return haskell#imports#import_statements(remainder, a:agg + [statement])
  endif
endfunction "}}}

function! s:strip_import_keywords(a) abort "{{{
  return substitute(a:a, '^' . s:import_prefix_re, '', '')
endfunction "}}}

function! haskell#imports#format_single_import(head, names, has_names) abort "{{{
  let head_suf = a:has_names ? ' (' . join(a:names)[:-2] . ')' : ''
  return [a:head . head_suf]
endfunction "}}}

function! haskell#imports#format_multi_import(head, names) abort "{{{
  let names = map(copy(a:names), { i, a -> '  ' . a})
  return [a:head . ' ('] + names + ['  )']
endfunction "}}}

function! haskell#imports#format_import(import) abort "{{{
  let names = map(s:sort(a:import.names), { i, a -> a . ',' })
  let head = substitute(a:import.head, '\v\s+', ' ', 'g')
  return a:import.multi ?
        \ haskell#imports#format_multi_import(head, names) :
        \ haskell#imports#format_single_import(head, names, a:import.has_names)
endfunction "}}}

function! s:compare_imports(l, r) abort "{{{
  let l = s:strip_import_keywords(a:l.head)
  let r = s:strip_import_keywords(a:r.head)
  return l == r ? 0 : (l > r ? 1 : -1)
endfunction "}}}

function! haskell#imports#merge_imports(imports) abort "{{{
  function! Folder(z, a) abort "{{{
    let [result, agg] = a:z
    if agg.has_names && a:a.has_names && agg.head == a:a.head
      let new_agg = {
            \ 'head': agg.head,
            \ 'has_names': 1,
            \ 'names': s:sort(agg.names + a:a.names),
            \ 'multi': agg.multi || a:a.multi
            \ }
      return [result, new_agg]
    else
      return [result + [agg], a:a]
    endif
  endfunction "}}}
  if len(a:imports) > 1
    let [init, last_] = list#fold_left({ z, a -> Folder(z, a) }, [[], a:imports[0]], a:imports[1:])
    return init + [last_]
  else
    return a:imports
  endif
endfunction "}}}

function! haskell#imports#sort_block(block) abort "{{{
  let [start, end] = a:block
  let lines = map(copy(range(start, end)), { i, l -> getline(l) })
  let imports = haskell#imports#import_statements(lines, [])
  let sorted = sort(copy(imports), { l, r -> s:compare_imports(l, r) })
  let merged = haskell#imports#merge_imports(sorted)
  let formatted = map(copy(merged), { i, imp -> haskell#imports#format_import(imp) })
  let updated_lines = list#concat(formatted)
  return {
        \ 'start': start,
        \ 'end': end,
        \ 'modified': lines != updated_lines,
        \ 'data': updated_lines,
        \ }
endfunction "}}}

function! haskell#imports#sort() abort "{{{
  if bufname('%') == ''
    return
  endif
  let view = winsaveview()
  let modified = v:false
  try
    let blocks = map(copy(haskell#imports#import_blocks()), { i, a -> haskell#imports#sort_block(a) })
    for block in reverse(blocks)
      if block.modified
        let modified = v:true
        keepjumps silent call deletebufline('%', block.start, block.end)
        keepjumps silent call append(block.start - 1, block.data)
      endif
    endfor
  finally
    call winrestview(view)
  endtry
  if modified
    keepjumps silent noautocmd w
  endif
endfunction "}}}

function! haskell#imports#sort_save() abort "{{{
  if &ft == 'haskell' && get(g:, 'haskell_sort_imports', 1)
    return haskell#imports#sort()
  endif
endfunction "}}}

function! haskell#imports#import_grep_query(import_type, identifier) abort "{{{
  if a:import_type == 'qualified'
    return '^import \S+ .* as ' . a:identifier
  elseif a:import_type == 'ctor'
    return '^import \S+ .*\b' . a:identifier . '\(' . a:identifier . '\)'
  else
    return '^import \S+ .*' . '\(.*\b' . a:identifier . '\b.*\)'
  endif
endfunction "}}}

function! haskell#imports#prompt_format(index, import) abort "{{{
  return string(a:index + 1) . ': ' . a:import
endfunction "}}}

function! haskell#imports#ask_match(results) abort "{{{
  let lines = ['Multiple matches:'] +
        \ map(copy(a:results), 'haskell#imports#prompt_format(v:key, v:val)')
  return inputlist(lines)
endfunction "}}}

function! haskell#imports#insert_into(import, local, module_base, module_line) abort "{{{
  let blocks = haskell#imports#import_blocks()
  if len(blocks) >= 2
    let lnum = (a:local ? blocks[1][0] : blocks[0][0]) - 1
    let matching = 1
  elseif len(blocks) == 1
    let block_lnum = blocks[0][0]
    let local_block = match(getline(block_lnum), '\v^import %(qualified )?' . a:module_base) != -1
    let matching = local_block == a:local
    let nonmatching_line = a:local ? blocks[0][-1] + 1 : block_lnum - 1
    let lnum = matching || ! a:local ? block_lnum - 1 : blocks[0][-1] + 1
  else
    keepjumps silent call cursor(module_line, 0)
    keepjumps silent let lnum = search('^$', 'Wn') + 1
    let matching = 0
  endif
  keepjumps silent call append(lnum, [a:import] + (matching ? [] : ['']))
  return 1
endfunction "}}}

function! haskell#imports#insert(module, identifier, import_type) abort "{{{
  let import_base = matchstr(a:module, '\v^\k+\ze')
  keepjumps silent let module_line = search('^module', 'c')
  if module_line == -1
    return 0
  endif
  let module_base = matchstr(getline(module_line), '\v^module \zs\k+\ze')
  let prefix = a:import_type == 'qualified' ? 'qualified ' : ''
  let infix = a:import_type == 'qualified' ? ' as ' . a:identifier : ''
  let names = a:import_type == 'ctor' ? ' (' . a:identifier . '(' . a:identifier . '))' :
        \ a:import_type == 'type' ? ' (' . a:identifier . ')' : ''
  let import = 'import ' . prefix . a:module . infix . names
  return haskell#imports#insert_into(import, module_base == import_base, module_base, module_line)
endfunction "}}}

function! s:import_module(result) abort "{{{
  return substitute(a:result, '\v^import %(qualified )?(\S+).*', '\1', '')
endfunction "}}}

function! s:trim_import_results(results) abort "{{{
  function! Contained(results, a) abort "{{{
    return empty(filter(copy(a:results), { i, b -> a:a[:len(b)+1] == b . '.' })) ? [a:a] : []
  endfunction "}}}
  return list#fold_left({ z, a -> z + Contained(a:results, a) }, [], a:results)
endfunction "}}}

function! haskell#imports#add_import() abort "{{{
  let view = winsaveview()
  let message = 'Inserting import failed'
  let success = 0
  try
    let ln = getline('.')
    let identifier = expand('<cword>')
    let col = getcurpos()[2]
    let qualified = match(ln, '.*\k*\%' . col . 'c\k*\..*') != -1
    let inline_sig = match(ln, ':: .*\%' . col . 'c') != -1
    let import_type =
          \ qualified ? 'qualified' :
          \ (haskell#indent#line_is_in_function_signature(line('.')) || inline_sig) ? 'type' :
          \ haskell#indent#line_is_in_function_equation(line('.')) ? 'ctor' : 'type'
    let query = haskell#imports#import_grep_query(import_type, identifier)
    let all_results = uniq(sort(map(ProGrepList(getcwd(), query), { i, a -> s:import_module(a.text) })))
    let results = s:trim_import_results(all_results)
    if len(results) == 0
      let message = 'No matches'
      return 0
    elseif len(results) == 1
      let import = results[0]
    else
      let response = haskell#imports#ask_match(results)
      if response > 0 && response <= len(results)
        let import = results[response - 1]
      else
        let success = 0
        let message = 'No result selected'
        return 0
      endif
    endif
    let success = haskell#imports#insert(import, identifier, import_type)
  finally
    if success
      keepjumps silent write
    endif
    call winrestview(view)
    silent redraw
    if success
      echo 'Added import of ' . import
    else
      echo message
    endif
  endtry
  return success
endfunction "}}}
