let g:myo_command_collect_api_dev = {
      \ 'ident': 'collect-api-dev',
      \ 'lines': ['ops/dev/ghcid-collect-api-dev.zsh'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'capture': v:true,
      \ }

let g:myo_command_collect = {
      \ 'ident': 'ghcid-collect',
      \ 'lines': ['ops/dev/ghcid-collect.zsh'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'capture': v:true,
      \ }

let g:myo_command_collect_exe = {
      \ 'ident': 'collect-exe',
      \ 'lines': ['nix-build -A ghc.bodhi-collect'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

function! s:setup() abort "{{{
  let g:myo_commands['system'] += [
        \ g:myo_command_collect_api_dev,
        \ g:myo_command_collect,
        \ g:myo_command_collect_exe,
        \ ]
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

let g:haskell_local_module_segments = 2
let g:haskell_packages_local_module_segments = {
  \ }
