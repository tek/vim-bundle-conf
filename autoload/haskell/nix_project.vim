let g:myo_haskell_nix_default_hpack = g:vbc_dir . '/project/haskell/nix-project/hpack.zsh'

let g:myo_command_hpack = {
      \ 'ident': 'hpack',
      \ 'lines': [get(g:, 'myo_haskell_nix_hpack', g:myo_haskell_nix_default_hpack)],
      \ 'skipHistory': v:true,
      \ 'displayName': 'hpack',
      \ }

function! Hpack() abort "{{{
  MyoRun hpack
endfunction "}}}

function! haskell#nix_project#setup_commands() abort "{{{
  let g:postsave += ['Hpack']
  let g:myo_commands['system'] += [g:myo_command_hpack]
endfunction "}}}

function! haskell#nix_project#setup() abort "{{{
  let g:proteome_tags_command = 'ops/tags.zsh'
  let g:proteome_tags_args = '{tagFile}'
  let g:htf = v:false
  let g:nix = v:true
  let g:haskell_nix_test_runner = 'ops/dev/ghcid-test.zsh'
  autocmd User MyoBuiltinsLoaded call haskell#nix_project#setup_commands()
endfunction "}}}
