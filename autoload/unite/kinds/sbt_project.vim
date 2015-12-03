function! unite#kinds#sbt_project#define() abort "{{{
  return g:unite_kind_sbt_project
endfunction "}}}

function! unite#kinds#sbt_project#add_root(candidate) abort "{{{
  call tek_bundle_misc#add_root_project(a:candidate.action__path)
  call tek_bundle_misc#activate_root(-1, 1)
endfunction "}}}

let g:unite_kind_sbt_project = {
      \ 'name': 'sbt_project',
      \ 'default_action': 'add_root',
      \ 'parents': [],
      \ 'action_table': {
      \   'add_root': {
      \     'func': function('unite#kinds#sbt_project#add_root'),
      \     'description': 'add root dir',
      \     }
      \   }
      \ }
