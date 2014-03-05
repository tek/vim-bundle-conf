nnoremap <silent> <leader>tp :SaveAll<Bar>call maque#ft#puppet#provision()<cr>
nnoremap <silent> <leader>tr :SaveAll<Bar>call maque#ft#puppet#reload()<cr>
nnoremap <silent> <leader>tR :SaveAll<Bar>call maque#ft#puppet#recreate()<cr>
nnoremap <silent> <leader>tu :SaveAll<Bar>call maque#ft#puppet#up()<cr>
nnoremap <silent> <leader>ts :SaveAll<Bar>call maque#ft#puppet#ssh()<cr>
nnoremap <silent> <leader>tn :call maque#ft#puppet#user_query_node()<cr>
