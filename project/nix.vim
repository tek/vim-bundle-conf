function! NixosRebuild(cmd) abort "{{{
  execute 'Myo ' . a:cmd . ' ' . g:proteome_active.name . ' ' . get(g:, 'nix_rebuild_extra', '')
endfunction "}}}

nnoremap <f5> <cmd>call NixosRebuild('test_nix_host')<cr>
nnoremap <f6> <cmd>call NixosRebuild('rebuild_nix_host')<cr>
