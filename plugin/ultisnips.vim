let g:UltiSnipsSnippetsDir = fnamemodify(expand('<sfile>:h').'/../ultisnips', ':p')
let g:UltiSnipsListSnippets = '<c-\>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'ultisnips']

inoremap <silent> <c-l> <esc>:call UltiSnips#JumpForwards()<cr>
snoremap <silent> <c-l> <esc>:call UltiSnips#JumpForwards()<cr>
