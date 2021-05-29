let s:docker_pane = {
  \ 'layout': 'make',
  \ 'ident': 'docker',
  \ 'position': 8,
  \ }

function! s:docker_build() abort "{{{
  let n = g:proteome_active.name
  return {
    \ 'ident': 'docker-build',
    \ 'target': 'docker',
    \ 'lines': ['docker build -t ocaml-' . n . ' .'],
    \ }
endfunction "}}}

function! s:docker_shell() abort "{{{
  let n = g:proteome_active.name
  return {
    \ 'ident': 'docker',
    \ 'target': 'docker',
    \ 'lines': ['docker run -v \$PWD:/' . n . '-build -w /' . n . '-build -it ocaml-' . n . ' bash'],
    \ }
endfunction "}}}

function! s:setup() abort "{{{
  let g:myo_ui = get(g:, 'myo_ui', {})
  let g:myo_ui['panes'] = get(g:myo_ui, 'panes', [])
  let g:myo_ui['panes'] += [s:docker_pane]
  call myo_commands#add([s:docker_build(), s:docker_shell()])
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

command! -nargs=+ Bzl call MyoLine({'line': <q-args>, 'target': 'docker'})
