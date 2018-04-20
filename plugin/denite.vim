nmap <silent> <leader>b :Denite buffer<cr>

call denite#custom#option('_', 'auto_resize', 1)
call denite#custom#option('_', 'reversed', 1)
call denite#custom#option('_', 'mode', 'normal')
call denite#custom#option('_', 'cursor_wrap', 1)
call denite#custom#option('_', 'highlight_mode_normal', 'CursorLine')

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

command! -nargs=+ DeniteGrep Denite -no-quit grep<args>

nnoremap <silent> <leader>aa :DeniteGrep :.:-s:<cr>
nnoremap <silent> <leader>ai :DeniteGrep :.:-i:<cr>
nnoremap <silent> <leader>ad :DeniteGrep<cr>
nnoremap <silent> <leader>aA :DeniteGrep :.:-t:<cr>

nnoremap <silent> <m-y> :Denite miniyank<cr>
