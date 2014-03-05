if !exists('g:ref_detect_filetype')
  let g:ref_detect_filetype = {}
endif

let g:ref_detect_filetype['ruby'] = 'ri'

let g:ref_no_default_key_mappings = 1


function! s:ref(mode) abort "{{{
  try
    call ref#jump(a:mode)
  catch /^ref:/
    call tek_misc#warn(v:exception)
  endtry
endfunction "}}}

nnoremap <silent> K :<C-u>call <sid>ref('normal')<CR>
vnoremap <silent> K :<C-u>call <sid>ref('visual')<CR>
