let g:proteome_base_dirs = ['~/code/ext', '~/code/tek', '~/code/tweag', '~/code/rec', '/var/tek/lib/repos']
let g:proteome_project_base_dirs = ['~/code/ext', '~/code/tek', '~/code/tweag', '~/code/rec', '/var/tek/lib/repos']
let g:proteome_type_base_dirs = {
      \ $VIMPACK: ['vim'],
      \ '/home/tek/code/tek/python/external': ['python']
      \ }
let g:proteome_all_projects_history = 1
let g:postsave += ['tek_bundle_misc#post_save']
let g:proteome_project_config = {
      \ 'baseDirs': [$HOME . '/code/ext', $HOME . '/code/tek', $HOME . '/code/tweag', '/var/tek/lib/repos'],
      \ 'projectTypes': {
      \   'vim': [$VIMPACK],
      \ },
      \ 'typeMap': {
      \  'python_nvim': ['python'] ,
      \ },
      \ 'langMap': {
      \  'python_nvim': 'python',
      \ },
      \ 'langsMap': {
      \  'scala': ['java'],
      \ },
      \ 'typeMarkers': {
      \   'scala': ['*.sbt', '*.sc'],
      \ 'java': ['gradlew'],
      \ },
      \ }
let g:proteome_grep_cmdline = 'rg --vimgrep --no-heading --ignore-file ' . $HOME .'/.agignore'
let g:proteome_buffers_current_last = v:true

nnoremap <silent> gaa <cmd>call ProGrep('\b' . tek_misc#regex_escaped_expand('<cword>') . '\b')<cr>
xnoremap <silent> gaa "ay<cmd>call ProGrep(tek_misc#regex_escaped(@a))<cr>
nnoremap <silent> <leader>aa :ProGrep<cr>
nnoremap <silent> <leader>b :ProBuffers<cr>
nnoremap <silent> <insert> :ProNext<cr>
nnoremap <silent> <del> :ProPrev<cr>
nnoremap <silent> <leader>e :ProFiles<cr>
" nnoremap <silent> <c-insert> :ProTo 0<cr>
" nnoremap <silent> <leader>1 :Projects<cr>
" nnoremap <silent> <leader>2 :ProSelectAdd -start-insert<cr>

command! -nargs=+ -complete=file Mv ProMove <args>
command! -nargs=+ -complete=file Cp ProCopy <args>
command! Rm ProRemove

let g:proteome_files_exclude_directories = []
let g:proteome_files_exclude_files = ['.*\.pyc']
