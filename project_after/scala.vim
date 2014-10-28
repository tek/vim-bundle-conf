MaqueAddCapturedService 'sbt', {
      \ 'start': 1,
      \ 'create_minimized': 0,
      \ 'compiler': 'sbt_scala',
      \ }
MaqueAddCommand 'compile', {
      \ 'name': 'compile',
      \ 'pane_name': 'sbt',
      \ 'nested': 1,
      \ 'depend': ['sbt'],
      \ 'compiler': 'sbt_scala',
      \ }
MaqueAddCommand exists('g:project_android') ? 'android:run' : 'run', {
      \ 'name': 'run',
      \ 'pane_name': 'sbt',
      \ 'nested': 1,
      \ 'depend': ['sbt'],
      \ 'compiler': 'sbt_scala',
      \ }

nnoremap <silent> <f5> :MaqueRunCommand run<cr>
nnoremap <silent> <f6> :MaqueRunCommand compile<cr>
nnoremap <silent> <f7> :MaqueToggleCommand log<cr>
nnoremap <silent> <f8> :MaqueTmuxFocus sbt<cr>

let g:ctrlp_custom_ignore['dir'] .= '|/%(project/target|project/project|target|bin|gen)'
let g:maque_tmux_error_pane = 'sbt'
