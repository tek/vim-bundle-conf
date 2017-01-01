let s:override = exists("g:override_project_android")

let g:output_name = get(g:, 'logcat_output_name', g:project_name)

let g:droid_log_cmd = 'while true; do adb logcat -s ' . g:output_name . ':D' .
        \ ' \*:E System.out:I; done'

if g:use_myo
  MyoTmuxCreatePane log { 'parent': 'main', 'min_size': 0.2, 'max_size': 10,
        \ 'position': 0.5 }
  MyoShellCommand log { 'eval': True, 'line': 'var:droid_log_cmd',
        \ 'target': 'log', 'pinned': True }
  call _sbt_project_cmd('install', 'android:install')
  call _sbt_project_cmd('uninstall', 'android:uninstall')
  nnoremap <silent> <s-f5> :MyoRun install<cr>
  nnoremap <silent> <s-f7> :MyoRun uninstall<cr>
  nnoremap <silent> <s-f2> :MyoRunChained run s:vimtest<cr>
else
  MaqueAddService 'while true; do adb logcat -s ' . g:output_name . ':D' .
        \ ' AndroidRuntime:E; done', { 'name': 'log', 'size': 30,
        \ 'manual_termination': 1, 'capture': 1, 'minimized_size': 5,
        \ 'start': 1, 'position': 0.5 }

  MaqueAddCommand 'rm **/proguard-cache*.jar', {
          \ 'name': 'delete proguard cache',
          \ }

  for params in [
        \ ['ainstall', 'tek#bundle#scala#sbt_prefixed("android:install")', 1],
        \ ['arun', 'tek#bundle#scala#sbt_prefixed("android:run")', 1],
        \ ]
    call call('CreateSbtCommand', params)
  endfor

  augroup maque_scala_android_project
    autocmd!
    autocmd User MaqueTmuxMake MaqueTmuxClearLog log
  augroup END
endif

let g:ctrlp_custom_ignore['dir'] .= '|<%(bin|gen)>'
