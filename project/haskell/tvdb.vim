let g:myo_command_build = {
      \ 'ident': 'build',
      \ 'lines': ['nix-build --no-link -A ghc.tvdb'],
      \ 'target': 'make',
      \ 'kill': v:true,
      \ }

function! s:setup() abort "{{{
  let g:myo_commands['system'] += [
        \ g:myo_command_build,
        \ ]
endfunction "}}}

autocmd User MyoBuiltinsLoaded call s:setup()

if g:myo_builtins_loaded
  call s:setup()
endif

let g:haskell_nix_project = v:true
let g:myo_haskell_stack = v:false
let g:myo_haskell_nix_hpack = $PWD . '/ops/hpack.zsh'
