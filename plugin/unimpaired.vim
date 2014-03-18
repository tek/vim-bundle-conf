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

function! s:cursor(dir) abort "{{{
  let qf = getqflist()
  let cmd = ''
  if s:unite_open()
    let cmd = s:unite_cmd(a:dir)
  elseif !empty(qf)
    let cmd = s:qflist_cmd(a:dir)
  elseif !empty(getloclist(0))
    let cmd = s:loclist_cmd(a:dir)
  elseif exists(':MaqueParse')
    MaqueParse
  endif
  if len(cmd) > 0
    execute 'silent! normal ' . cmd . 'zv'
  endif
endfunction "}}}

nmap <silent> <up> :call <sid>cursor('up')<cr>
nmap <silent> <down> :call <sid>cursor('down')<cr>
