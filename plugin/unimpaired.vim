function! s:unite_open() abort "{{{
  return bufwinnr('unite') >= 0
endfunction "}}}

function! s:unite_cmd(dir) abort "{{{
  return a:dir == 'up' ? '[u' : ']u'
endfunction "}}}

function! s:unimpaired_cmd(dir, target) abort "{{{
  return "\<plug>unimpaired" . a:target . (a:dir == 'up' ? 'Previous' : 'Next')
endfunction "}}}

function! s:qflist_cmd(dir) abort "{{{
  return s:unimpaired_cmd(a:dir, 'Q')
endfunction "}}}

function! s:loclist_cmd(dir) abort "{{{
  return s:unimpaired_cmd(a:dir, 'L')
endfunction "}}}

function! s:cursor_regular(dir) abort "{{{
  let cmd = ''
  if s:unite_open()
    let cmd = s:unite_cmd(a:dir)
  elseif !empty(getqflist())
    let cmd = s:qflist_cmd(a:dir)
  elseif !empty(getloclist(0))
    let cmd = s:loclist_cmd(a:dir)
  elseif exists(':MaqueParse')
    MaqueParse
  endif
  return cmd
endfunction "}}}

function! s:cursor_diff(dir) abort "{{{
  let cmd = ''
  if index(['up', 'down'], a:dir) != -1
    let cmd = (a:dir == 'up' ? '[' : ']') . 'c'
  elseif index(['left', 'right'], a:dir) != -1
    let win = tabpagewinnr(tabpagenr())
    let left = a:dir == 'left'
    if win == 1
      " left window
      let cmd = 'd' . (left ? 'o' : 'p')
    elseif win == 2
      " right window
      let cmd = 'd' . (left ? 'p' : 'o')
    endif
  endif
  return cmd
endfunction "}}}

function! s:cursor(dir) abort "{{{
  if &diff
    let cmd = s:cursor_diff(a:dir)
  else
    let cmd = s:cursor_regular(a:dir)
  endif
  if len(cmd) > 0
    execute 'silent! normal ' . cmd . 'zv'
  endif
endfunction "}}}

nnoremap <silent> <up> :call <sid>cursor('up')<cr>
nnoremap <silent> <down> :call <sid>cursor('down')<cr>
nnoremap <silent> <left> :call <sid>cursor('left')<cr>
nnoremap <silent> <right> :call <sid>cursor('right')<cr>
