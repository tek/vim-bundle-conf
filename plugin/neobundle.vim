" install newly added bundles
command! Bn :silent! w<Bar>so ~/.vim/vim.vim<Bar>NeoBundleInstall<cr>

" update all bundles
command! Bu :silent! w<Bar>so ~/.vim/vim.vim<Bar>NeoBundleInstall!<cr>
