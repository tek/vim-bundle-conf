let g:UltiSnipsSnippetsDir='~/.vim/tek/ultisnips'
let g:UltiSnipsListSnippets='<c-\>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'ultisnips']

inoremap <silent> <c-l> <esc>:call UltiSnips_JumpForwards()<cr>
snoremap <silent> <c-l> <esc>:call UltiSnips_JumpForwards()<cr>
