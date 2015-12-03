let g:maque_tmux_async = 1
let g:maque_set_ft_options = 1
let g:maque_tmux_kill_signals = ['TERM', 'KILL']
let g:maque_unite_tmux_pane_ignore += ['main', 'aux', 'bg']

function! s:set_make_size() abort "{{{
  let make_size = maque#tmux#window_width() - 85
  execute 'MaqueTmuxSetLayoutSize make ' . make_size
endfunction "}}}

autocmd User MaqueTmuxDefaultPanesCreated call <sid>set_make_size()
