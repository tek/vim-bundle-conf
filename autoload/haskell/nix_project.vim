function! haskell#nix_project#hpack() abort "{{{
  
endfunction "}}}

let g:myo_command_hpack = {
      \ 'ident': 'hpack',
      \ 'lines': [g:vbc_dir . '/project/haskell/nix-project/hpack.zsh'],
      \ 'target': 'make',
      \ 'skipHistory': v:true,
      \ }

function! haskell#nix_project#setup_commands() abort "{{{
  let g:myo_commands['system'] += [g:myo_command_hpack]
endfunction "}}}

function! haskell#nix_project#setup() abort "{{{
  let g:proteome_tags_command = 'ops/tags.zsh'
  let g:proteome_tags_args = '{tagFile}'
  let g:htf = v:false
  let g:hedgehog = v:true
  let g:hedgehog_runner = 'ops/dev/ghcid-test.zsh'
  autocmd User MyoBuiltinsLoaded call haskell#nix_project#setup_commands()
endfunction "}}}
