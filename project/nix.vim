let g:flake = filereadable('flake.nix')

let g:myo_command_nix_build = {
      \ 'ident': 'build',
      \ 'lines': ['nix -L build --no-link'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_nix_flake_check = {
      \ 'ident': 'check',
      \ 'lines': ['nix -L flake check'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_nix_flake_update = {
      \ 'ident': 'update',
      \ 'lines': ['nix flake update'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'skipHistory': v:true,
      \ }

function! NixSetup() abort "{{{
  if g:flake
    call myo_commands#add(
      \ [
      \ g:myo_command_nix_build,
      \ g:myo_command_nix_flake_check,
      \ g:myo_command_nix_flake_update,
      \ ]
      \ )
  endif
endfunction "}}}

let g:nix = v:true
autocmd User MyoBuiltinsLoaded call NixSetup()
if g:myo_builtins_loaded
  call NixSetup()
endif
nnoremap <silent> <f5> <cmd>MyoRun check<cr>
nnoremap <silent> <f6> <cmd>MyoRun update<cr>
