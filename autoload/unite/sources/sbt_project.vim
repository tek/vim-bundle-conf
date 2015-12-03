function! unite#sources#sbt_project#define() abort "{{{
  return g:unite_source_sbt_project
endfunction "}}}

function! unite#sources#sbt_project#gather_candidates(args, context) abort "{{{
  let res = []
  for project in glob(g:scala_project_dir . '/*', 0, 1)
    let candidate = {
          \ 'word': fnamemodify(project, ':t'),
          \ 'action__path': project
          \ }
    call add(res, candidate)
  endfor
  return res
endfunction "}}}

let g:unite_source_sbt_project = {
      \ 'name': 'sbt_project',
      \ 'gather_candidates':
      \   function('unite#sources#sbt_project#gather_candidates'),
      \ 'default_kind': 'sbt_project'
      \ }
