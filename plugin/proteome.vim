let g:proteome_config_path = tek_misc#script_dir(expand('<sfile>')) .
      \ '/../config/proteome_projects'
let g:proteome_plugins = [
      \ 'proteome.plugins.ctags',
      \ 'proteome.plugins.history',
      \ 'proteome.plugins.config',
      \ ]
let g:proteome_history_base = '~/usr/var/tmp/vim/history_prot'
let g:proteome_base_dirs = ['~/code', '/var/tek/lib/repos']
let g:proteome_type_base_dirs = {
      \ $VIMBUNDLES: ['vim'],
      \ '/home/tek/code/python/external': ['python']
      \ }
let g:proteome_all_projects_history = 1
let tek_misc#postsave_functions += ['tek_bundle_misc#post_save']


nnoremap <silent> <insert> :ProNext<cr>
nnoremap <silent> <del> :ProPrev<cr>
nnoremap <silent> <c-insert> :ProTo 0<cr>
nnoremap <silent> <c-PageUp> :ProHistoryNext<cr>
nnoremap <silent> <c-PageDown> :ProHistoryPrev<cr>