function! Test_project() abort "{{{
  return get(g:, 'htf_project_name', '')
endfunction "}}}

function! Compile_project() abort "{{{
  return get(g:, 'haskell_compile_project', Test_project())
endfunction "}}}

let g:ctrlp_custom_ignore['file'] .= '|codex\.tags|.*\.cabal'
let g:ctrlp_custom_ignore['dir'] .= '|/temp/'
let g:postsave += ['haskell#imports#sort_save']
