let g:myo_command_cinema_api_dev = {
      \ 'ident': 'cinema-api-dev',
      \ 'lines': ['ops/dev/ghcid-cinema-api-dev.zsh'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'capture': v:true,
      \ }

let g:myo_command_cinema = {
      \ 'ident': 'ghcid-cinema',
      \ 'lines': ['ops/dev/ghcid-cinema.zsh'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'capture': v:true,
      \ }

let g:myo_command_cinema_exe = {
      \ 'ident': 'cinema-exe',
      \ 'lines': ['nix-build -A ghc.bodhi-cinema'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

function! s:setup() abort "{{{
  let g:myo_commands['system'] += [
        \ g:myo_command_cinema_api_dev,
        \ g:myo_command_cinema,
        \ g:myo_command_cinema_exe,
        \ ]
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

let g:haskell_local_module_segments = 2
let g:haskell_packages_local_module_segments = {
  \ }
