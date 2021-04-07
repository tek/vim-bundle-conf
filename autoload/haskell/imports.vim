let s:import_start_re = '\v^%(--\s\s+)?import '
let s:import_prefix_re = '\vimport\s+(%("[^"]+"\s+|[a-z]+\s+)*)'
let s:import_re = '\v^(--\s*)?(' . s:import_prefix_re . '(\S+)(%(\s+as \S+)?%(\s+hiding)?))\s*%((\(.*\)))?$'
let s:name_re = '%([^,()]+|\([^,()]+\))\s*'
let s:ctor_re = s:name_re . '%(,\s*)?'
let s:type_re = '\v%(%(type|pattern)\s+)?' . s:name_re
let s:names_re = '\v^' . s:type_re . '%(\(%(' . s:ctor_re . ')*\))?\zs,\s*'

function! s:find_block_end(found, current) abort "{{{
  keepjumps let end = search('\v^(%(--\s\s+)?import|\s)@!', 'W')
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

function! haskell#imports#all_imports() abort "{{{
  let blocks = haskell#imports#import_blocks()
  if empty(blocks)
    return [0, 0]
  else
    return [blocks[0][0], blocks[-1][1]]
  endif
endfunction "}}}

function! s:compare_names(l, r) abort "{{{
  let left_op = a:l[:0] == '('
  let right_op = a:r[:0] == '('
  return left_op ? (right_op ? a:l[1:] ># a:r[1:] : 1) : (right_op ? -1 : a:l ># a:r)
endfunction "}}}

function! s:sort(names) abort "{{{
  return uniq(sort(copy(a:names), { l, r -> s:compare_names(l, r) }))
endfunction "}}}

function! s:parse_names(match) abort "{{{
  let names = substitute(a:match, '\v^\((.*)\)$', '\1', '')
  return s:sort(map(split(names, s:names_re), { i, a -> trim(a) }))
endfunction "}}}

function! haskell#imports#import_statement(cur, tail) abort "{{{
  let multi = len(a:tail) > 0
  let import = matchlist(join([a:cur] + a:tail, ' '), s:import_re)
  let head_match = get(import, 2, '')
  let head = len(head_match) > 0 ? head_match : get(import, 0, a:cur)
  let names_match = get(import, 6, '')
  return {
        \ 'head': head,
        \ 'comment': !empty(get(import, 1, '')),
        \ 'qualifiers': get(import, 3, ''),
        \ 'module': get(import, 4, ''),
        \ 'has_names': len(names_match) > 0,
        \ 'suffix': get(import, 5, ''),
        \ 'names': s:parse_names(names_match),
        \ 'multi': multi,
        \ }
endfunction "}}}

function! haskell#imports#import_statements(block) abort "{{{
  let block = a:block
  let result = []
  while len(block) != 0
    let [cur; rest] = block
    let next_index = match(rest, s:import_start_re)
    let [tail, block] = next_index == 0 ? [[], rest] : (
          \ next_index == -1 ? [rest, []] : [rest[:next_index - 1], rest[next_index:]]
          \ )
    let statement = haskell#imports#import_statement(cur, tail)
    call add(result, statement)
  endwhile
  return result
endfunction "}}}

function! s:format_head(import) abort "{{{
  let comment = a:import.comment ? '-- ' : ''
  let head = comment . 'import ' . a:import.qualifiers . ' ' . a:import.module . ' ' . a:import.suffix
  return trim(substitute(head, '\v\s+', ' ', 'g'))
endfunction "}}}

function! haskell#imports#format_single_import(head, names, has_names) abort "{{{
  let head_suf = a:has_names ? ' (' . join(a:names)[:-2] . ')' : ''
  let head = a:head . head_suf
  return [substitute(head, '\v\s+', ' ', 'g')]
endfunction "}}}

function! haskell#imports#format_multi_import(head, names) abort "{{{
  let names = map(copy(a:names), { i, a -> '  ' . a})
  return [a:head . ' ('] + names + ['  )']
endfunction "}}}

function! haskell#imports#format_import(import) abort "{{{
  let names = map(s:sort(a:import.names), { i, a -> a . ',' })
  let head = s:format_head(a:import)
  return a:import.multi ?
        \ haskell#imports#format_multi_import(head, names) :
        \ haskell#imports#format_single_import(head, names, a:import.has_names)
endfunction "}}}

function! s:compare_imports(l, r) abort "{{{
  let l = a:l.module
  let r = a:r.module
  return l == r ? (a:r.has_names && a:l.has_names ? 0 : (a:r.has_names ? -1 : a:l.has_names)) : (l > r ? 1 : -1)
endfunction "}}}

function! s:mergeable(agg, a) abort "{{{
  return a:agg.has_names &&
        \ a:a.has_names &&
        \ a:agg.comment == a:a.comment &&
        \ a:agg.qualifiers == a:a.qualifiers &&
        \ a:agg.module == a:a.module &&
        \ a:agg.suffix == a:a.suffix
endfunction "}}}

function! haskell#imports#merge_imports(imports) abort "{{{
  function! Folder(z, a) abort "{{{
    let [result, agg] = a:z
    if s:mergeable(agg, a:a)
      let new_agg = {
            \ 'head': agg.head,
            \ 'comment': agg.comment,
            \ 'qualifiers': agg.qualifiers,
            \ 'module': agg.module,
            \ 'has_names': 1,
            \ 'suffix': agg.suffix,
            \ 'names': agg.names + a:a.names,
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

function! haskell#imports#block_statements(block) abort "{{{
  let [start, end] = a:block
  let lines = map(copy(range(start, end)), { i, l -> getline(l) })
  return [lines, haskell#imports#import_statements(filter(lines, { i, a -> !empty(a) }))]
endfunction "}}}

function! haskell#imports#sort_block_stmts(imports) abort "{{{
  let sorted = sort(copy(a:imports), { l, r -> s:compare_imports(l, r) })
  let merged = haskell#imports#merge_imports(sorted)
  let formatted = map(copy(merged), { i, imp -> haskell#imports#format_import(imp) })
  return list#concat(formatted)
endfunction "}}}

function! haskell#imports#sort_block(block) abort "{{{
  let [lines, imports] = haskell#imports#block_statements(a:block)
  let updated_lines = haskell#imports#sort_block_stmts(imports)
  return {
        \ 'start': a:block[0],
        \ 'end': a:block[1],
        \ 'modified': lines != updated_lines,
        \ 'data': updated_lines,
        \ }
endfunction "}}}

function! s:segments() abort "{{{
  let packages = get(g:, 'haskell_packages_local_module_segments', {})
  let package = haskell#imports#file_package()
  let global_max = get(g:, 'haskell_local_module_segments', 2)
  return get(packages, package, global_max)
endfunction "}}}

function! haskell#imports#module_prefix(module, max) abort "{{{
  let modules = split(a:module, '\.')
  return modules[:a:max - 1]
endfunction "}}}

function! haskell#imports#split() abort "{{{
  let [module_line, file_module] = haskell#imports#current_module()
  if empty(file_module)
    return []
  endif
  let max = s:segments()
  let prefix = haskell#imports#module_prefix(file_module, max)
  let block = haskell#imports#all_imports()
  let [lines, imports] = haskell#imports#block_statements(block)
  function! Split(prefix, max, blocks, import) abort "{{{
    if a:prefix == haskell#imports#module_prefix(a:import.module, a:max)
      return [a:blocks[0], a:blocks[1] + [a:import]]
    else
      return [a:blocks[0] + [a:import], a:blocks[1]]
    endif
  endfunction "}}}
  let split_imports = list#fold_left({ z, a -> Split(prefix, max, z, a) }, [[], []], imports)
  let sorted = map(split_imports, { i, a -> haskell#imports#sort_block_stmts(a) })
  let spacer = empty(sorted[0]) || empty(sorted[1]) ? [] : ['']
  let updated_lines = sorted[0] + spacer + sorted[1]
  return [{
        \ 'start': block[0],
        \ 'end': block[1],
        \ 'modified': lines != (sorted[0] + sorted[1]),
        \ 'data': updated_lines,
        \ }]
endfunction "}}}

function! haskell#imports#sort() abort "{{{
  if bufname('%') == ''
    return
  endif
  let view = winsaveview()
  let modified = v:false
  try
    if get(g:, 'haskell_imports_split', 1)
      let sorted_blocks = haskell#imports#split()
    else
      let blocks = haskell#imports#import_blocks()
      let sorted_blocks = map(copy(blocks), { i, a -> haskell#imports#sort_block(a) })
    endif
    for block in reverse(sorted_blocks)
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
  let ident = '[a-zA-Z0-9_.]+'
  let name = '(?:' . ident . '|\([^)]+\))'
  let elem = '\s*(?:' . ident . '(?:\((?:' . name . '(?:, )?)+\))?(?:,\n?)?\s*)'
  let pre = '^import\s+(?:"[^"]+"\s+|[a-z]+\s+)*(\S+)'
  let type = pre . '(?:\s+as)?\s+' . '\((?m:\n?' . elem . '*?\s*)'
  if a:import_type == 'qualified'
    return pre . '\s+as\s+' . a:identifier . '\b.*'
  elseif a:import_type == 'ctor'
    return type . ident . '\s*\(' . a:identifier . '\).*'
  else
    return type . '\b' . a:identifier . '\b.*'
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

function! s:match_module_prefix(prefix, module) abort "{{{
  return a:prefix == split(a:module, '\.')[:len(a:prefix) - 1]
endfunction "}}}

function! s:import_module(import) abort "{{{
  return matchstr(a:import, s:import_prefix_re . '\zs%(\k|\.)+\ze')
endfunction "}}}

function! haskell#imports#insert_into(import, local, module_base, module_line, import_base) abort "{{{
  let blocks = haskell#imports#import_blocks()
  if len(blocks) >= 2
    let local_mod = s:import_module(getline(blocks[1][0]))
    let lnum = (s:match_module_prefix(a:import_base, local_mod) || a:local ? blocks[1][0] : blocks[0][0]) - 1
    let matching = 1
  elseif len(blocks) == 1
    let block_lnum = blocks[0][0]
    let local_mod = s:import_module(getline(block_lnum))
    let local_block = s:match_module_prefix(a:module_base, local_mod)
    let matching = local_block == a:local
    let nonmatching_line = a:local ? blocks[0][-1] + 1 : block_lnum - 1
    let lnum = matching || ! a:local ? block_lnum - 1 : blocks[0][-1] + 1
  else
    keepjumps silent call cursor(a:module_line, 0)
    keepjumps silent let lnum = search('^$', 'Wn')
    let matching = 0
  endif
  keepjumps silent call append(lnum, [a:import] + (matching ? [] : ['']))
  return 1
endfunction "}}}

function! haskell#imports#current_module() abort "{{{
  keepjumps silent let module_line = search('^module', 'cnbw')
  return [module_line, matchstr(getline(module_line), '\v^module \zs\S+\ze')]
endfunction "}}}

function! haskell#imports#file_package() abort "{{{
  let fn = expand('%')
  let package = substitute(fn, '\v%(^|.*/)packages/([^/]+)/.*', '\1', '')
  return fn == package ? '' : package
endfunction "}}}

function! haskell#imports#prefixes(file_module, import_module) abort "{{{
  let max = s:segments()
  let file_modules = split(a:file_module, '\.')
  let import_modules = split(a:import_module, '\.')
  return [file_modules[:max - 1], import_modules[:max - 1]]
endfunction "}}}

function! haskell#imports#insert(module_line, file_module, import_module, identifier, import_type) abort "{{{
  let [module_base, import_base] = haskell#imports#prefixes(a:file_module, a:import_module)
  let prefix = a:import_type == 'qualified' ? 'qualified ' : ''
  let infix = a:import_type == 'qualified' ? ' as ' . a:identifier : ''
  let names = a:import_type == 'ctor' ? ' (' . a:identifier . '(' . a:identifier . '))' :
        \ a:import_type == 'type' || a:import_type == 'function' ? ' (' . a:identifier . ')' : ''
  let import = 'import ' . prefix . a:import_module . infix . names
  return haskell#imports#insert_into(import, module_base == import_base, module_base, a:module_line, import_base)
endfunction "}}}

function! s:import_module(result) abort "{{{
  return substitute(a:result, s:import_prefix_re . '(\S+).*', '\3', '')
endfunction "}}}

function! haskell#imports#trim_import_results(file_module, results) abort "{{{
  function! StartsWith(a, b) abort "{{{
    return a:a[:len(a:b)] == (a:b . '.')
  endfunction "}}}
  function! Valid(results, a) abort "{{{
    return empty(filter(copy(a:results), { i, b -> StartsWith(a:a, b) })) ? [a:a] : []
  endfunction "}}}
  function! FilterExports(results) abort "{{{
    return list#fold_left({ z, a -> z + Valid(a:results, a) }, [], a:results)
  endfunction "}}}
  let non_cyclical = filter(copy(a:results), { i, a -> !StartsWith(a:file_module, a) })
  let safe = FilterExports(non_cyclical)
  return empty(safe) ? FilterExports(a:results) : safe
endfunction "}}}

function! haskell#imports#type_application(ln, col) abort "{{{
  let nearest_at = match(a:ln, '\v\@[^@]*%' . a:col . 'c')
  let between = a:ln[nearest_at + 1 : a:col - 1]
  return nearest_at > 0 && (
        \ between =~ '^\k*$' ||
        \ substitute(between, '[^(]', '', 'g') > substitute(between, '[^)]', '', 'g')
        \ )
endfunction "}}}

function! haskell#imports#current_word() abort "{{{
  let ln = getline('.')
  let identifier = expand('<cword>')
  let ticked = identifier[:0] == ''''
  let unticked = ticked ? identifier[1:] : identifier
  let col = getcurpos()[2]
  let qualified = match(ln, '.*\k*\%' . col . 'c\k*\..*') != -1
  let sig = haskell#indent#line_is_in_function_signature(line('.'))
  let inline_sig = match(ln, ':: .*\%' . col . 'c') != -1
  let equation = haskell#indent#line_is_in_function_equation(line('.'))
  let app = equation && haskell#imports#type_application(ln, col)
  let family = haskell#indent#line_is_in_family(line('.'))
  let import_type =
        \ qualified ? 'qualified' :
        \ unticked =~# '^[a-z]' ? 'function' :
        \ (sig || inline_sig || app || family) ? 'type' :
        \ (equation || ticked) ? 'ctor' : 'type'
  return [unticked, import_type]
endfunction "}}}

function! s:file_module(path) abort "{{{
  let contents = readfile(a:path)
  let mod = matchlist(contents, '\v^module ([^( ]+)')
  return empty(mod) ? [] : [mod[1]]
endfunction "}}}

function! haskell#imports#find_definition(identifier, import_type) abort "{{{
  let query =
        \ a:import_type == 'function' ? '^\s*' . a:identifier . ' ::' :
        \ a:import_type == 'qualified' ? '^data ' . a:identifier . ' ' :
        \ a:import_type == 'ctor' ? '^(data|newtype) ' . a:identifier . ' ' :
        \ '^\s*(data|newtype|class(.*=>)?|type( family)?) \b' . a:identifier . ' '
  return list#concat(map(ProGrepList('.', '', query), { i, a -> s:file_module(a.path) }))
endfunction "}}}

function! haskell#imports#search_existing(identifier, import_type) abort "{{{
  let query = haskell#imports#import_grep_query(a:import_type, a:identifier)
  let opt = '--multiline -r $1'
  return map(ProGrepList('.', opt, query), { i, a -> a.text })
endfunction "}}}

function! haskell#imports#add_import_with(find_info) abort "{{{
  let view = winsaveview()
  let message = 'Inserting import failed'
  let success = 0
  try
    let [module_line, file_module] = haskell#imports#current_module()
    if empty(file_module)
      let message = 'No module declaration'
      return 0
    endif
    let [identifier, import_type] = call(a:find_info, [])
    let import_search_results = haskell#imports#search_existing(identifier, import_type)
    let definition_results = haskell#imports#find_definition(identifier, import_type)
    let all_results = uniq(sort(import_search_results + definition_results))
    let results = haskell#imports#trim_import_results(file_module, all_results)
    if empty(results)
      let message = 'No matches'
      return 0
    elseif len(results) == 1
      let import = results[0]
    else
      let response = haskell#imports#ask_match(results)
      if response > 0 && response <= len(results)
        let import = results[response - 1]
      else
        let message = 'No result selected'
        return 0
      endif
    endif
    let success = haskell#imports#insert(module_line, file_module, import, identifier, import_type)
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

function! haskell#imports#add_import_cword() abort "{{{
  return haskell#imports#add_import_with('haskell#imports#current_word')
endfunction "}}}
