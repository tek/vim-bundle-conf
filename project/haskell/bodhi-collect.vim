let g:myo_command_collect_api_dev = {
      \ 'ident': 'collect-api-dev',
      \ 'lines': ['nix run .#collect-api-dev'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'capture': v:true,
      \ }

let g:myo_command_collect = {
      \ 'ident': 'ghcid-collect',
      \ 'lines': ['nix run .#collect'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'capture': v:true,
      \ }

let g:myo_command_collect_exe = {
      \ 'ident': 'collect-exe',
      \ 'lines': ['nix build .#bodhi-collect'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

function! s:setup() abort "{{{
  call myo_commands#add([
    \ g:myo_command_collect_api_dev,
    \ g:myo_command_collect,
    \ g:myo_command_collect_exe,
    \ ]
    \ )
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

let g:haskell_local_module_segments = 2
let g:haskell_packages_local_module_segments = {
  \ }
