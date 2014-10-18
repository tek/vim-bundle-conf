let g:UltiSnipsSnippetsDir = fnamemodify(expand('<sfile>:h').'/../ultisnips', ':p')
let g:UltiSnipsListSnippets = '<c-\>'
let g:UltiSnipsExpandTrigger = '<plug>(nop)'
let g:UltiSnipsJumpForwardTrigger = '<plug>(nop)'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'ultisnips']
let g:UltiSnipsRemoveSelectModeMappings = 0

inoremap <expr> <silent> <c-l> UltiSnips#JumpForwards()
snoremap <silent> <c-l> <c-o>:call UltiSnips#JumpForwards()<cr>

inoremap <silent> <tab> <c-r>=tek_bundle_misc#ulti_snips_jump_or_expand()<cr>
snoremap <silent> <tab> <esc>:call tek_bundle_misc#ulti_snips_jump_or_expand()<cr>
