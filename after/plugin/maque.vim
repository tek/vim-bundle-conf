if !g:use_myo
  let g:maque_tmux_async = 1
  let g:maque_set_ft_options = 1
  let g:maque_tmux_kill_signals = ['TERM', 'KILL']
  let g:maque_unite_tmux_pane_ignore += ['main', 'aux', 'bg']
  let g:maque_use_make_fallback = 0
  " let g:maque_tmux_bracketed_paste = 1

  function! s:set_make_size() abort "{{{
    let make_size = maque#tmux#window_width() - 90
    execute 'MaqueTmuxSetLayoutSize make ' . make_size
  endfunction "}}}

  autocmd User MaqueTmuxDefaultPanesCreated call <sid>set_make_size()

  if exists('g:project_bootstrapped') && g:project_detected
    MaqueAddService 'tig status', {
          \ 'name': 'tig',
          \ 'pane': 'main',
          \ 'capture': 0,
          \ }
  endif

  function! s:tig() abort "{{{
    MaqueTmuxZoom main
    MaqueRunCommand tig
    return ''
  endfunction "}}}

  nnoremap <expr> <silent> <c-f1> <sid>tig()

  command! Tig call <sid>tig()
endif
