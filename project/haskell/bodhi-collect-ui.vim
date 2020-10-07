let g:proteome_files_exclude_directories = ['result', 'build-output']

let g:myo_command_frontend = {
      \ 'ident': 'frontend',
      \ 'lines': ['ops/dev/ghcid-frontend.zsh'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'capture': v:true,
      \ }

let g:myo_command_android = {
      \ 'ident': 'android-debug-build',
      \ 'lines': ['nix-build -A android.frontend'],
      \ 'target': 'make',
      \ }

function! s:setup() abort "{{{
  let g:myo_commands['system'] += [
        \ g:myo_command_frontend,
        \ g:myo_command_android,
        \ ]
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

let g:haskell_nix_project = v:true
let g:myo_haskell_stack = v:false
