" install newly added bundles
command! Bn :silent! w<Bar>so ~/.config/nvim/init.vim<Bar>NeoBundleInstall<cr>

" update all bundles
command! Bu :silent! w<Bar>so ~/.config/nvim/init.vim<Bar>NeoBundleInstall!<cr>
