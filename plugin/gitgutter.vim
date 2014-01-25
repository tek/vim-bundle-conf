let g:gitgutter_map_keys = 0
let g:gitgutter_enabled = 0

call submode#enter_with('gitgutter', 'n', 'r', '<leader>G', 'zR:GitGutterEnable<cr>')
call submode#map('gitgutter', 'n', 'rs', 'j', '<Plug>GitGutterNextHunk')
call submode#map('gitgutter', 'n', 'rs', 'k', '<Plug>GitGutterPrevHunk')
call submode#map('gitgutter', 'n', 'rs', 'a', '<Plug>GitGutterStageHunk')
call submode#map('gitgutter', 'n', 'rs', 'u', '<Plug>GitGutterRevertHunk')
call submode#map('gitgutter', 'n', 'sx', '<esc>', ':GitGutterDisable<cr>')
call submode#map('gitgutter', 'n', 'sx', 'c', ':GitGutterDisable<cr>:Gcommit<cr>')
call submode#map('gitgutter', 'n', 'sx', 'd', ':GitGutterDisable<cr>:Gdiff<cr>')
