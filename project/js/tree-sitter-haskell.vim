let g:test#runners = { 'javascript': ['treesitter'] }
let g:test#enabled_runners = ['javascript#treesitter']

function! s:format() abort "{{{
  s/\S\zs /\r/g
  nohlsearch
  normal! =ap
endfunction "}}}

command! Fmt call s:format()

function! ToggleTest() abort "{{{
  call test#javascript#treesitter#toggle()
  return MyoVimTest()
endfunction "}}}

nnoremap <f5> <cmd>Myo ./test.zsh -g<cr>
nnoremap <f6> <cmd>Myo script/parse-examples<cr>
nnoremap <s-f2> <cmd>call ToggleTest()<cr>
nnoremap <f14> <cmd>call ToggleTest()<cr>
