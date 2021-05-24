let g:proteome_files_exclude_directories = ['result', 'build-output']

let g:myo_command_build_backend = {
      \ 'ident': 'build-backend',
      \ 'lines': ['nix build .#backend'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_frontend = {
      \ 'ident': 'frontend',
      \ 'lines': ['nix run --impure .#frontend'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'capture': v:true,
      \ }

function! s:setup() abort "{{{
  call myo_commands#add([
    \ g:myo_command_build_backend,
    \ g:myo_command_frontend,
    \ ])
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

let g:haskell_local_module_segments = 2
