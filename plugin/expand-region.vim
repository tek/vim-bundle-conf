call expand_region#custom_text_objects({
      \ 'ii' :0, 
      \ 'i_' :0, 
      \ })

call expand_region#custom_text_objects('ruby', {
      \ 'ir' :1,
      \ 'ar' :1,
      \ })

call expand_region#custom_text_objects('python', {
      \ 'if' :0,
      \ })
