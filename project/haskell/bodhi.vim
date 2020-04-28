let g:htf = v:true

let g:haskell_project_map = {
      \ 'core': 'bodhi-core',
      \ 'api': 'bodhi-api',
      \ 'client': 'bodhi-client',
      \ 'web': 'bodhi-web',
      \ 'db': 'bodhi-db',
      \ 'broker': 'bodhi-broker',
      \ 'prelude': 'bodhi-prelude',
      \ 'test': 'bodhi-test',
      \ }

let g:proteome_files_exclude_directories = ['result', 'build-output']

let g:myo_command_ob_run = {
      \ 'ident': 'ob-run',
      \ 'lines': ['ob run'],
      \ 'target': 'ghci'
      \ }

function! s:setup() abort "{{{
  let g:myo_commands['system'] += [g:myo_command_ob_run]
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

let g:proteome_tags_command = 'ops/tags.zsh'
let g:proteome_tags_args = '{tagFile}'
