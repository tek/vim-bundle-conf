call expand_region#custom_text_objects({
      \ 'ii' :0, 
      \ 'i,e' :0, 
      \ 'i_' :0, 
      \ })

let g:expand_region_text_objects_ruby = copy(g:expand_region_text_objects)
call remove(g:expand_region_text_objects_ruby, 'ip')
call expand_region#custom_text_objects('ruby', {
      \ 'ir' :1,
      \ 'in' :1,
      \ })

call expand_region#custom_text_objects('python', {
      \ 'if' :0,
      \ })

nmap <bs> <Plug>(expand_region_expand)
xmap <bs> <Plug>(expand_region_expand)
xmap <leader><bs> <Plug>(expand_region_shrink)
