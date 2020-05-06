function! Test_project() abort "{{{
  return get(g:, 'htf_project_name', '')
endfunction "}}}

function! Compile_project() abort "{{{
  return get(g:, 'haskell_compile_project', Test_project())
endfunction "}}}

nnoremap <silent> <f5> :MyoRun stack-test<cr>
nnoremap <silent> <s-f5> :MyoRun stack-test-lenient<cr>
nnoremap <silent> <f17> :MyoRun stack-test-lenient<cr>
nnoremap <silent> <f6> :MyoRun stack-build<cr>
nnoremap <silent> <s-f6> :MyoRun stack-build-lenient<cr>
nnoremap <silent> <f18> :MyoRun stack-build-lenient<cr>
nnoremap <silent> <f7> :MyoRun stack-clean<cr>
nnoremap <silent> <s-f7> :MyoRun stack-clean-all<cr>
nnoremap <silent> <f19> :MyoRun stack-clean-all<cr>

let g:ctrlp_custom_ignore['file'] .= '|codex\.tags|.*\.cabal'
let g:ctrlp_custom_ignore['dir'] .= '|/temp/'
let g:postsave += ['haskell#imports#sort_save']

if get(g:, 'haskell_nix_project', 0)
  call haskell#nix_project#setup()
endif
