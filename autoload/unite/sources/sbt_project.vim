function! unite#sources#sbt_project#define() abort "{{{
  return g:unite_source_sbt_project
endfunction "}}}

function! unite#sources#sbt_project#gather_candidates(args, context) abort "{{{
  let res = []
  for base in g:scala_project_dirs
    for project in glob(base . '/*', 0, 1)
      let candidate = {
            \ 'word': fnamemodify(project, ':t'),
            \ 'action__path': project
            \ }
      call add(res, candidate)
    endfor
  endfor
  return res
endfunction "}}}

let g:unite_source_sbt_project = {
      \ 'name': 'sbt_project',
      \ 'gather_candidates':
      \   function('unite#sources#sbt_project#gather_candidates'),
      \ 'default_kind': 'sbt_project'
      \ }
