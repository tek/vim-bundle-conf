let g:proteome_files_exclude_directories = ['result', 'build-output']

let g:myo_command_build_obelisk = {
      \ 'ident': 'build-obelisk',
      \ 'lines': ['nix build .#bodhi-obelisk'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

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

let g:myo_command_android = {
      \ 'ident': 'android-debug-build',
      \ 'lines': ['nix-build -A android.frontend'],
      \ 'target': 'make',
      \ }

let g:myo_command_android_install = {
      \ 'ident': 'android-debug-install',
      \ 'lines': ['ops/android-app.zsh'],
      \ 'target': 'make',
      \ }

function! s:setup() abort "{{{
  call myo_commands#add([
    \ g:myo_command_build_obelisk,
    \ g:myo_command_build_backend,
    \ g:myo_command_frontend,
    \ ])
        " \ g:myo_command_android,
        " \ g:myo_command_android_install,
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

let g:haskell_local_module_segments = 2
