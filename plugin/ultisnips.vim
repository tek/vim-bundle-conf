let g:UltiSnipsSnippetsDir = fnamemodify(expand('<sfile>:h').'/../ultisnips', ':p')
let g:UltiSnipsListSnippets = '<c-\>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'ultisnips']

inoremap <silent> <c-l> <c-o>:call UltiSnips#JumpForwards()<cr>
snoremap <silent> <c-l> <c-o>:call UltiSnips#JumpForwards()<cr>
