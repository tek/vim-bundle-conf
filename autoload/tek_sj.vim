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
        \ '\w+%(\[.{-}\])?%(\(.{-}\))?' . 
        \ '%(\s*:\s*\w[^={]*)?' . 
        \ '%(\s*\=)?' .
        \ '\zs' .
        \ '%(\s*\{\s*)?' . 
        \ '([^{].{-})' .
        \ '(\s*\}\s*)?$'

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
  let pattern = '\v<if\s*%(\(.*\))\s*\zs([^{].*)'

  if line =~ pattern
    call sj#ReplaceMotion('V', substitute(line, pattern, '{\n\1\n}', ''))
    return 1
  endif
endfunction "}}}
