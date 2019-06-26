let g:proteome_config_path = tek_misc#script_dir(expand('<sfile>')) .
      \ '/../config/proteome_projects'
let g:proteome_history_base = '~/usr/var/tmp/vim/history'
let g:proteome_base_dirs = ['~/code/ext', '~/code/tek', '~/code/spr', '~/code/rec', '/var/tek/lib/repos']
let g:proteome_project_base_dirs = ['~/code/ext', '~/code/tek', '~/code/spr', '~/code/rec', '/var/tek/lib/repos']
let g:proteome_type_base_dirs = {
      \ $VIMPACK: ['vim'],
      \ '/home/tek/code/tek/python/external': ['python']
      \ }
let g:proteome_all_projects_history = 1
let tek_misc#postsave_functions += ['tek_bundle_misc#post_save']
let g:proteome_project_config = {
      \ 'projectTypes': {},
      \ 'typeMap': {
      \  'python_nvim': ['python'] ,
      \ },
      \ 'langMap': {
      \  'python_nvim': 'python' ,
      \ },
      \ 'langsMap': {
      \ },
      \ 'typeMarkers': {
      \ }
      \ }
let g:proteome_grep_cmdline = 'rg --vimgrep --no-heading --ignore-file ' . $HOME .'/.agignore'

nnoremap <silent> gaa <cmd>call ProGrep('\b' . expand('<cword>') . '\b')<cr>
xnoremap <silent> gaa "ay<cmd>call ProGrep('\b' . @a)<cr>
nnoremap <silent> <leader>aa :ProGrep<cr>
nnoremap <silent> <leader>b :ProBuffers<cr>
nnoremap <silent> <insert> :ProNext<cr>
nnoremap <silent> <del> :ProPrev<cr>
" nnoremap <silent> <c-insert> :ProTo 0<cr>
" nnoremap <silent> <leader>1 :Projects<cr>
" nnoremap <silent> <leader>2 :ProSelectAdd -start-insert<cr>
