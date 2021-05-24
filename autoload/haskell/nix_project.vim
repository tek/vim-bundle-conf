let g:flake = filereadable('flake.nix')

let s:hpack_cmd = g:flake ? 'nix run .#hpack' : get(g:, 'myo_haskell_nix_hpack', g:myo_haskell_nix_default_hpack)

let g:myo_command_hpack = {
      \ 'ident': 'hpack',
      \ 'lines': [s:hpack_cmd],
      \ 'skipHistory': v:true,
      \ 'displayName': 'hpack',
      \ }

let g:myo_command_nix_build = {
      \ 'ident': 'build',
      \ 'lines': ['nix -L build --no-link'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_nix_flake_check = {
      \ 'ident': 'flake-check',
      \ 'lines': ['nix -L flake check'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

let g:myo_command_nix_flake_update = {
      \ 'ident': 'flake-update',
      \ 'lines': ['nix flake update'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'skipHistory': v:true,
      \ }

let g:myo_command_nix_flake_update_hix = {
      \ 'ident': 'flake-update-hix',
      \ 'lines': ['nix flake lock --update-input hix'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ 'skipHistory': v:true,
      \ }

function! haskell#nix_project#setup_commands() abort "{{{
  let g:postsave += ['Hpack']
  call myo_commands#add([g:myo_command_hpack])
  if g:flake
    call myo_commands#add([
      \ g:myo_command_nix_build,
      \ g:myo_command_nix_flake_check,
      \ g:myo_command_nix_flake_update,
      \ g:myo_command_nix_flake_update_hix,
      \ ])
  endif
endfunction "}}}

function! haskell#nix_project#setup() abort "{{{
  let g:proteome_tags_command = 'nix run .#tags --'
  let g:proteome_tags_args = '{tagFile}'
  let g:htf = v:false
  let g:nix = v:true
  let g:haskell_nix_test_runner = g:flake ? 'nix run ''.#ghcid-test'' --' : 'ops/dev/ghcid-test.zsh'
  let g:myo_test_capture = v:true
  let g:myo_haskell_stack = v:false
  let g:myo_haskell_nix_hpack = $PWD . '/ops/hpack.zsh'
  autocmd User MyoBuiltinsLoaded call haskell#nix_project#setup_commands()
  if g:myo_builtins_loaded
    call haskell#nix_project#setup_commands()
  endif
  nnoremap <silent> <f5> <cmd>MyoRun flake-check<cr>
  nnoremap <silent> <f6> <cmd>MyoRun flake-update<cr>
  nnoremap <silent> <f7> <cmd>MyoRun flake-update-hix<cr>
endfunction "}}}

autocmd! BufWritePost *.yaml call Hpack()
