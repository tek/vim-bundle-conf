let g:neomake_java_enabled_makers = []
let g:neomake_enabled_makers = ['gradle']

nnoremap <silent> <m-i> :JCimportAddSmart<cr>

let g:JavaComplete_ImportSortType = 'packageName'
let g:JavaComplete_ImportOrder = ['java.', 'javax.', 'org.', 'net.', 'com.artnology.']
