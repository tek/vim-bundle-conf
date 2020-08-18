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

let g:myo_command_api_dev = {
      \ 'ident': 'api-dev',
      \ 'lines': ['ops/dev/ghcid-api-dev.zsh'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_cinema_api_dev = {
      \ 'ident': 'cinema-api-dev',
      \ 'lines': ['ops/dev/ghcid-cinema-api-dev.zsh'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_collect = {
      \ 'ident': 'ghcid-collect',
      \ 'lines': ['ops/dev/ghcid-collect.zsh'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_cinema = {
      \ 'ident': 'ghcid-cinema',
      \ 'lines': ['ops/dev/ghcid-cinema.zsh'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_collect_exe = {
      \ 'ident': 'collect-exe',
      \ 'lines': ['nix-build -A ghc.bodhi'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_cinema_exe = {
      \ 'ident': 'cinema-exe',
      \ 'lines': ['nix-build -A ghc.bodhi-cinema'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_build_collect = {
      \ 'ident': 'build-collect',
      \ 'lines': ['ops/build.zsh'],
      \ 'target': 'make',
      \ }

function! s:setup() abort "{{{
  let g:myo_commands['system'] += [
        \ g:myo_command_api_dev,
        \ g:myo_command_cinema_api_dev,
        \ g:myo_command_collect,
        \ g:myo_command_cinema,
        \ g:myo_command_collect_exe,
        \ g:myo_command_cinema_exe,
        \ g:myo_command_build_collect,
        \ ]
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

let g:haskell_nix_project = v:true
let g:myo_haskell_stack = v:false
let g:myo_haskell_nix_hpack = $PWD . '/ops/hpack.zsh'
