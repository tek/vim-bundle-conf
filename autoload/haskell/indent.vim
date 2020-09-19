let s:indented_line = '\v\s*\S.*$'

function! s:find_backwards_while(lnum, target, accept) abort "{{{
  let line = getline(a:lnum)
  return line =~ a:target ? a:lnum :
        \ (line =~ a:accept ? s:find_backwards_while(a:lnum - 1, a:target, a:accept) : -1)
endfunction "}}}

function! s:find_backwards_while_same_indent(lnum, target) abort "{{{
  let ind = repeat(' ', indent(a:lnum))
  let accept = '\v^' . ind
  return s:find_backwards_while(a:lnum, a:target, accept)
endfunction "}}}

function! haskell#indent#is_comment(line) abort "{{{
  return a:line =~ '^\s*--'
endfunction "}}}

function! haskell#indent#function_signature(lnum) abort "{{{
  return s:find_backwards_while(a:lnum, '\v^\s*\S+\s+::.*$', s:indented_line)
endfunction "}}}

function! haskell#indent#function_equation(lnum) abort "{{{
  return s:find_backwards_while(a:lnum, '\v^\s*%(type |data |class |instance )@!\S+.* \=($| )', s:indented_line)
endfunction "}}}

function! haskell#indent#class_or_instance(lnum) abort "{{{
  return s:find_backwards_while(a:lnum, '\v^\s*%(class |instance )', s:indented_line)
endfunction "}}}

function! haskell#indent#family(lnum) abort "{{{
  return s:find_backwards_while(a:lnum, '\v^\s*%(type family )', s:indented_line)
endfunction "}}}

function! s:line_is(lnum, rex) abort "{{{
  return getline(a:lnum) =~ a:rex
endfunction "}}}

function! haskell#indent#line_is_dollar(lnum) abort "{{{
  return s:line_is(a:lnum, '\v.*\$\s*$')
endfunction "}}}

function! haskell#indent#line_is_single_arrow(lnum) abort "{{{
  return s:line_is(a:lnum, '\v.*\-\>\s*$')
endfunction "}}}

function! haskell#indent#line_is_definite_block_start(lnum) abort "{{{
  return s:line_is(a:lnum, '\v.*%(<of| \=| \&|<rec|<mdo|<do|<where|<let|<class|<instance| ::|\{|\[|\\case|\>--?|\\)\s*$')
endfunction "}}}

function! haskell#indent#line_is_in_function_signature(lnum) abort "{{{
  return haskell#indent#function_signature(a:lnum) != -1 && haskell#indent#function_equation(a:lnum) == -1
endfunction "}}}

function! haskell#indent#line_is_in_function_equation(lnum) abort "{{{
  return haskell#indent#function_equation(a:lnum) != -1
endfunction "}}}

function! haskell#indent#line_is_in_family(lnum) abort "{{{
  return haskell#indent#family(a:lnum) != -1
endfunction "}}}

function! haskell#indent#line_is_block_start_with_arrow(lnum) abort "{{{
  let rex = '\v%(\s*∀.*\.|.*[=-]\>)\s*$'
  return getline(a:lnum) =~ rex && s:find_backwards_while(a:lnum, '\v%(.*::|^instance$)\s*$', rex) == -1
endfunction "}}}

function! haskell#indent#line_is_block_start_with_enumerator(line) abort "{{{
  return a:line =~ '\v.*\<-\s*$'
endfunction "}}}

function! haskell#indent#line_is_block_start_with_dollar(lnum) abort "{{{
  return haskell#indent#line_is_dollar(a:lnum) && (
        \ getline(a:lnum) =~ '\v\s\<-\s' ||
        \ ! (
        \ haskell#indent#line_is_dollar(a:lnum - 1) ||
        \ haskell#indent#line_is_block_start(a:lnum - 1)
        \ )
        \ )
endfunction "}}}

function! haskell#indent#line_is_block_start(lnum) abort "{{{
  let line = getline(a:lnum)
  return !haskell#indent#is_comment(line) && (
        \ haskell#indent#line_is_definite_block_start(a:lnum) ||
        \ haskell#indent#line_is_block_start_with_arrow(a:lnum) ||
        \ haskell#indent#line_is_block_start_with_enumerator(line) ||
        \ haskell#indent#line_is_block_start_with_dollar(a:lnum)
        \ )
endfunction "}}}

let s:guard_rex = '\v^\s*\|\s'

function! haskell#indent#line_is_guard(lnum) abort "{{{
  return getline(a:lnum) =~ s:guard_rex
endfunction "}}}

function! haskell#indent#line_is_first_guard(lnum) abort "{{{
  return haskell#indent#line_is_guard(a:lnum) && (!haskell#indent#line_is_guard(a:lnum - 1))
endfunction "}}}

function! haskell#indent#line_is_in_class_or_instance(lnum) abort "{{{
  return haskell#indent#function_signature(a:lnum) == -1 &&
        \ haskell#indent#function_equation(a:lnum) == -1 &&
        \ haskell#indent#class_or_instance(a:lnum) != -1
endfunction "}}}

function! haskell#indent#keep_indent(lnum) abort "{{{
  return indent(a:lnum)
endfunction "}}}

function! haskell#indent#indent_after_block_start(lnum) abort "{{{
  return indent(a:lnum - 1) + 2
endfunction "}}}

function! haskell#indent#indent_in_block(lnum) abort "{{{
  return min([indent(a:lnum), indent(a:lnum - 1)])
endfunction "}}}

function! haskell#indent#function_name(lnum) abort "{{{
  return get(matchlist(getline(a:lnum), '\v^\s*(\S+) .*\=$'), 1, '')
endfunction "}}}

function! haskell#indent#indent_function_equation(lnum) abort "{{{
  let current = haskell#indent#keep_indent(a:lnum)
  let name = haskell#indent#function_name(a:lnum)
  if name == ''
    return current
  else
    let sig = s:find_backwards_while_same_indent(a:lnum, '\v^\s*' . name . ' ::')
    return sig == -1 ? current : indent(sig)
  endif
endfunction "}}}

function! haskell#indent#indent_function_signature(lnum) abort "{{{
  let sig = haskell#indent#function_signature(a:lnum)
  return sig == a:lnum ?
        \ indent(a:lnum) :
        \ sig == a:lnum - 1 ?
        \ haskell#indent#indent_after_block_start(a:lnum) :
        \ indent(a:lnum - 1)
endfunction "}}}

function! haskell#indent#indent_class_or_instance(lnum) abort "{{{
  let current = indent(a:lnum)
  let line = getline(a:lnum)
  let start_re = '^(instance|class) .*'
  return line =~ start_re ?  0 :
        \ line =~ '\s*) => .*' ?  2 :
        \ 4
endfunction "}}}

function! haskell#indent#indent_function_body(lnum) abort "{{{
  return haskell#indent#function_equation(a:lnum) == a:lnum ?
        \ haskell#indent#indent_function_equation(a:lnum) :
        \ haskell#indent#line_is_block_start(a:lnum - 1) || haskell#indent#line_is_first_guard(a:lnum) ?
        \ haskell#indent#indent_after_block_start(a:lnum) :
        \ haskell#indent#indent_in_block(a:lnum)
endfunction "}}}

function! haskell#indent#indent_decl(lnum) abort "{{{
  return haskell#indent#line_is_in_function_signature(a:lnum) ?
        \ haskell#indent#indent_function_signature(a:lnum) :
        \ haskell#indent#line_is_in_class_or_instance(a:lnum) ?
        \ haskell#indent#indent_class_or_instance(a:lnum) :
        \ haskell#indent#indent_function_body(a:lnum)
endfunction "}}}

function! haskell#indent#is_intro_line(lnum) abort "{{{
  return getline(a:lnum) =~ '\v^%(import|module|\s*\)\s*<where)>'
endfunction "}}}

function! haskell#indent#new_import_line(lnum) abort "{{{
  return getline(a:lnum - 1) =~ '\v%(.*\)|^import .*\w)$'
endfunction "}}}

function! haskell#indent#indent_intro(lnum, target, start) abort "{{{
  return (haskell#indent#is_intro_line(a:lnum) || haskell#indent#new_import_line(a:lnum)) ? 0 : 2
endfunction "}}}

function! haskell#indent#last_zero_indent_line() abort "{{{
  return search('^\S.*$', 'bnW')
endfunction "}}}

function! haskell#indent#context_indent(lnum, target, prev) abort "{{{
  let last_zero = haskell#indent#last_zero_indent_line()
  return ((last_zero > 0) && haskell#indent#is_intro_line(last_zero)) ?
        \ haskell#indent#indent_intro(a:lnum, a:target, last_zero) :
        \ haskell#indent#indent_decl(a:lnum)
endfunction "}}}

function! haskell#indent#indentexpr() abort "{{{
  let target = getline(v:lnum)
  let prev = getline(v:lnum - 1)
  return (prev =~ '^\s*$') ? 0 : haskell#indent#context_indent(v:lnum, target, prev)
endfunction "}}}
