function! tek_conque#delete_buffer() "{{{
  if exists('g:test_conque')
    silent! exe 'autocmd! '.term_name
    exe 'py '.g:test_conque_name.'.close()'
    silent! exe 'py '.g:test_conque_name.'.auto_read()'
    silent! exe 'bwipeout! '.g:test_conque.buffer_name
    unlet g:test_conque
    augroup conque_test
      autocmd!
    augroup end
    cclose
  endif
endfunction "}}}

function! tek_conque#run_unittest(...) "{{{
  call tek_conque#delete_buffer()
	let cmd = a:0 > 0 ? a:1 : &makeprg
  let remain = tek_misc#want('g:leave_conque_window')
  let split = tek_misc#want('g:conque_horizontal') ? 'botright vsplit' : 'botright split'
  let g:test_conque = conque_term#open(cmd, [split], remain)
  let g:test_conque_name = 'ConqueTerm_'.g:test_conque.idx
  if tek_misc#want('g:test_conque_nowrap')
    exe 'py '.g:test_conque_name.'.working_columns = 100000'
  endif
  let nr = bufnr(g:test_conque.buffer_name)
  if exists('*populate#unlock_all') && !remain
    call populate#unlock_all()
    exe 'augroup conque_test'
    exe 'autocmd BufEnter <buffer='.nr.'> PopulateLock'
    exe 'autocmd BufLeave <buffer='.nr.'> silent! PopulateUnlock'
    exe 'augroup end'
  endif
  if remain
    stopinsert
  endif
endfunction "}}}

function! tek_conque#make(...) "{{{
  return call('tek_conque#run_unittest', a:000)
endfunction "}}}

function! tek_conque#write_errorfile(origin_name) "{{{
  stopinsert
  let in_conque = &ft == 'conque_term'
  if !in_conque
    call tek_misc#activate_window_by_name(g:test_conque.buffer_name)
  endif
  silent exe 'w! '.&errorfile
  if in_conque && len(a:origin_name)
    call tek_misc#activate_window_by_name(a:origin_name)
  else
    wincmd p
  endif
endfunction "}}}

function! tek_conque#remove_errorfile() "{{{
	exe 'silent !'.'rm -f '.&ef
  redraw!
endfunction "}}}

function! tek_conque#parse_output(origin_name) "{{{
  call tek_conque#write_errorfile(a:origin_name)
  cgetfile
  call tek_conque#remove_errorfile()
  let nr = winnr()
  call tek_misc#activate_window_by_name(g:test_conque.buffer_name)
  copen
  exe nr.'wincmd w'
	clast
  normal! zv
endfunction "}}}

function! tek_conque#start_service(cmd) "{{{
  let proc = conque_term#open(a:cmd, ['split'])
  wincmd c
  return proc
endfunction "}}}
