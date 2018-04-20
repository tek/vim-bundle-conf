let g:airline_powerline_fonts=1
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#tmuxline#enabled = 0

set noshowmode
let g:airline_mode_map = {
      \ 'c': 'C',
      \ '^S': 'SB',
      \ 'R': 'R',
      \ 's': 'S',
      \ 't': 'TERM',
      \ 'V': 'VL',
      \ '^V': 'VB',
      \ 'i': 'I',
      \ '__': '-',
      \ 'S': 'SL',
      \ 'v': 'V',
      \ 'n': 'N',
      \ }
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 79,
    \ 'x': 60,
    \ 'y': 84,
    \ 'z': 45,
    \ }

autocmd User AirlineAfterInit call tek_airline#init()
