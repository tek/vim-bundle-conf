let s:func_keywords = '%(def|var|val)'

function! tek_sj#join_scala_function() abort "{{{
  let line = getline('.')
  let def_pattern = '\v<' . s:func_keywords .
        \ ' \w+%(\[.*\])?%(\(.*\))?\s*%(:\s*\w[^={]*)?\s*'
  let def_eq_pattern = def_pattern . '\=\s*\{$'
  let def_prod_pattern = def_pattern . '\{$'
  let end_pattern = '\v^\s*}$'
  let is_prod = line =~ def_prod_pattern
  if line !~ def_eq_pattern && !is_prod
    return 0
  endif
  let def_line_no = line('.')
  let end_line_no = line('.') + 2
  let endline = getline(end_line_no)
  if endline !~ end_pattern
    return 0
  endif
  let lines = sj#GetLines(def_line_no, end_line_no)
  if is_prod
    let new_line = line . ' '
  else
    let new_line = substitute(line, '\s*=\?\s*{$', ' = ', '')
  endif
  let new_line .= sj#Trim(lines[1])
  if is_prod
    let new_line .= ' }'
  endif
  call sj#ReplaceLines(def_line_no, end_line_no, new_line)
  return 1
endfunction "}}}

function! tek_sj#split_scala_function() abort "{{{
  let line = getline('.')
  let pattern =
        \ '\v<' . s:func_keywords . ' ' .
        \ '\k+%(\[.{-}\])?%(\(.{-}\))?' .
        \ '%(\s*:\s*\w[^=]*)?' .
        \ ' \=\zs (.*)$'

  if line =~ pattern
    call sj#ReplaceMotion('V', substitute(line, pattern, ' {\n\1\n}', ''))
    return 1
  endif
endfunction "}}}

function! tek_sj#split_scala_if() abort "{{{
  let line = getline('.')
  let pattern = '\v<if\s*%(\(.*\))\s*\zs([^{].*)'

  if line =~ pattern
    call sj#ReplaceMotion('V', substitute(line, pattern, '{\n\1\n}', ''))
    return 1
  endif
endfunction "}}}

function! tek_sj#split_scala_block() abort "{{{
  let line = getline('.')
  let pattern = '\v\{\zs.*\ze\}'
  if line =~ pattern
    call sj#ReplaceMotion('V', substitute(line, pattern, '\n&\n', ''))
    return 1
  endif
endfunction "}}}

function! tek_sj#split_scala_package() abort "{{{
  let line = getline('.')
  let pattern = '\v^package %(\w|\.)*\zs\.(\w+)$'
  if line =~ pattern
    call sj#ReplaceMotion('V', substitute(line, pattern, '\npackage \1', ''))
    return 1
  endif
endfunction "}}}

function! tek_sj#join_scala_package_import() abort "{{{
  let pattern = '\v^(package|import) ((%(\w|\.){-1,})%(\._)?)$'
  let this_line_no = line('.')
  let next_line_no = this_line_no + 1
  let this_line = getline(this_line_no)
  let next_line = getline(next_line_no)
  if this_line !~ pattern || next_line !~ pattern
    return 0
  endif
  let new_line =
        \ substitute(this_line, pattern, '\1 \3', '') .
        \ substitute(next_line, pattern, '.\2', '')
  call sj#ReplaceLines(this_line_no, next_line_no, new_line)
  return 1
endfunction "}}}

function! tek_sj#split_scala_import() abort "{{{
  let line = getline('.')
  let pattern = '\v^import %(\w|\.){}\zs\.(_@!\w+%(\._)?)$'
  if line =~ pattern
    call sj#ReplaceMotion('V', substitute(line, pattern, '._\nimport \1', ''))
    return 1
  endif
endfunction "}}}

function! tek_sj#split_scala_params() abort "{{{
  let line = getline('.')
  let pattern = '\v^([^(]*)\((.*)\)([^)]*)$'
  if line =~ pattern
    let params = substitute(line, pattern, '\2', '')
    let trailingComma = substitute(params, '[^,]\zs$', ',', '')
    let paramLines = substitute(trailingComma, ',\s*', ',\n', 'g')
    let replacement = substitute(line, pattern, '\1(\n' . paramLines . ')\3', '')
    call sj#ReplaceMotion('V', replacement)
    return 1
  endif
endfunction "}}}

function! tek_sj#single_line_with(pattern, replacement, flags) abort "{{{
  let line = getline('.')
  if line =~ a:pattern
    call sj#ReplaceMotion('V', substitute(line, a:pattern, a:replacement, a:flags))
    return 1
  endif
endfunction "}}}

function! tek_sj#single_line(pattern, replacement) abort "{{{
  return tek_sj#single_line_with(a:pattern, a:replacement, '')
endfunction "}}}

function! tek_sj#multi_line(pattern, replacement) abort "{{{
  let line_patterns = split(a:pattern, '\\n')
  let lno = line('.')
  let line = getline('.')
  let line_count = len(line_patterns)
  let matches = map(copy(line_patterns), {index, pat -> match(line, pat) >= 0})
  let cursor_pattern_index = index(matches, 1)
  if cursor_pattern_index >= 0
    let start_line = lno - cursor_pattern_index
    let end_line = lno + line_count - cursor_pattern_index
    let lines = getline(start_line, end_line - 1)
    let text = join(lines, "\n")
    let result = substitute(text, a:pattern, a:replacement, '')
    call sj#ReplaceLines(start_line, end_line - 1, result)
    return 1
  endif
endfunction "}}}

function! tek_sj#join_python_do() abort "{{{
  return tek_sj#multi_line(
        \ '\v^( *)\@do\((.*)\)\n( *def .* -\> )Do:$',
        \ '\1\3\2:',
        \ )
endfunction "}}}

function! tek_sj#split_python_do() abort "{{{
  return tek_sj#single_line(
        \ '\v^( *)(def .* -\> )%(Do)@!(.*):$',
        \ '\1@do(\3)\n\1\2Do:',
        \ )
endfunction "}}}

function! tek_sj#haskell_type_param_split(ws, types) abort "{{{
  let split_quantifiers = substitute(a:types, '\v^%(forall|∀)%(\w|[ ''])+\.\zs\s*', a:ws . '\n  ', '')
  return substitute(split_quantifiers, '\v%(\([^)]*)@<![-=]\>\zs\s*', '\n  ' . a:ws, 'g')
endfunction "}}}

function! tek_sj#split_haskell_sig() abort "{{{
  let pattern = '\v(^(\s*)%(pattern\s*)?\S+ ::) (.*)'
  let replacement = '\=submatch(1) . "\n" . tek_sj#haskell_type_param_split(submatch(2), submatch(3))'
  return tek_sj#single_line(pattern, replacement)
endfunction "}}}

function! tek_sj#split_haskell_decl() abort "{{{
  let pattern = '\v(.* \=) (.*)'
  return tek_sj#single_line(pattern, '\1\n\2')
endfunction "}}}

function! tek_sj#haskell_import_list_split(imports) abort "{{{
  let with_trailing_comma = substitute(a:imports, '[^,]\zs$', ',', '')
  return "\n  " . substitute(with_trailing_comma, '\v%(\([^)]*)@<!,\zs\s*\ze', "\n  ", 'g')
endfunction "}}}

function! tek_sj#split_haskell_import() abort "{{{
  let line = getline('.')
  if line =~ '^import [^(]*(.*)$'
    let replacement = '\=tek_sj#haskell_import_list_split(submatch(0))'
    call sj#ReplaceMotion('V', substitute(line, '[^(](\zs.*\ze)', replacement, ''))
    return 1
  endif
endfunction "}}}
