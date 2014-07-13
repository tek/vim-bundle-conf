call expand_region#custom_text_objects({
      \ 'ii' :0, 
      \ 'i,w' :0, 
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

map <bs> <Plug>(expand_region_expand)
