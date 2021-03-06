let g:test#javascript#treesitter#generate = v:true

function! s:generate() abort "{{{
  return get(g:, 'test_generate', v:true)
endfunction "}}}

function! test#javascript#treesitter#toggle() abort "{{{
  let g:test_generate = !s:generate()
endfunction "}}}

function! test#javascript#treesitter#test_file(fname) abort "{{{
  return a:fname =~ '\v%(^|.*/)corpus/.*\.txt'
endfunction "}}}

function! test#javascript#treesitter#build_position(type, position) abort "{{{
  let lnum = search('\v\=+\n\zs.*\ze\n\=+$', 'bcnW')
  return lnum == -1 ? 0 : [getline(lnum)]
endfunction "}}}

function! test#javascript#treesitter#build_args(args) abort "{{{
  let gen = s:generate() ? ['-g'] : []
  return gen + ['''' . join(a:args) . '''']
endfunction "}}}

function! test#javascript#treesitter#executable() abort "{{{
  return './test.zsh'
endfunction "}}}
