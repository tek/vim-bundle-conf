function! tek_sj#join_scala_function() abort "{{{
  let line = getline('.')
  let def_pattern = '\v<def \w+%(\(.*\))?\s*\=?\s*\{$'
  let end_pattern = '\v^\s*}$'
  if line !~ def_pattern
    return 0
  endif
  let def_line_no = line('.')
  let end_line_no = line('.') + 2
  let endline = getline(end_line_no)
  if endline !~ end_pattern
    return 0
  endif
  let lines = sj#GetLines(def_line_no, end_line_no)
  let new_line = substitute(line, '\s*=\?\s*{$', ' = ', '')
  let new_line .= sj#Trim(lines[1])
  call sj#ReplaceLines(def_line_no, end_line_no, new_line)
  return 1
endfunction "}}}

function! tek_sj#split_scala_function() abort "{{{
  let line = getline('.')
  let pattern = '\v<def \w+%(\(.*\))?\s*\=\s*\zs([^{].*)'

  if line =~ pattern
    call sj#ReplaceMotion('V', substitute(line, pattern, '{\n\1\n}', ''))
    return 1
  endif
endfunction "}}}
