" nmap <silent> <leader>b :Denite buffer<cr>

call denite#custom#option('_', 'auto_resize', 1)
call denite#custom#option('_', 'reversed', 1)
call denite#custom#option('_', 'mode', 'normal')
call denite#custom#option('_', 'cursor_wrap', 1)
call denite#custom#option('_', 'highlight_mode_normal', 'CursorLine')
call denite#custom#option('_', 'highlight_matched_char', 'Normal')
" call denite#custom#option('_', 'split', 'floating')

if executable('ag')
	call denite#custom#var('grep', 'command', ['ag'])
	call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', [])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
elseif executable('rg')
	call denite#custom#var('grep', 'command', ['rg'])
	call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading', '--ignore-file', $HOME . '/.agignore'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('file_rec', 'command', ['rg', '--follow', '--hidden', '-l'])
endif

command! -nargs=+ DeniteGrep Denite grep<args>

" nnoremap <silent> <leader>aa :DeniteGrep :.:-s:<cr>
" nnoremap <silent> <leader>ai :DeniteGrep :.:-i:<cr>
" nnoremap <silent> <leader>ad :DeniteGrep<cr>
" nnoremap <silent> <leader>aA :DeniteGrep :.:-t:<cr>

" nnoremap <silent> <m-y> :Denite miniyank<cr>

function! s:denite_mappings() abort
  nnoremap <silent><buffer><expr> <cr>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> D
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select') . 'k'
endfunction<Paste>

autocmd FileType denite call s:denite_mappings()
