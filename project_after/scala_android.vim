let s:override = exists("g:override_project_android")

let g:output_name = get(g:, 'logcat_output_name', g:project_name)

let g:droid_log_cmd = 'while true; do adb logcat -s ' . g:output_name . ':D' .
        \ ' \*:E System.out:I; done'

MyoTmuxCreatePane log { 'parent': 'main', 'min_size': 0.2, 'max_size': 10,
      \ 'position': 0.5 }
MyoShellCommand log { 'eval': True, 'line': 'var:droid_log_cmd',
      \ 'target': 'log', 'pinned': True, 'history': False }
call _sbt_project_cmd('install', 'android:install')
call _sbt_project_cmd('uninstall', 'android:uninstall')
nnoremap <silent> <s-f5> :MyoRun install<cr>
nnoremap <silent> <s-f7> :MyoRun uninstall<cr>
nnoremap <silent> <s-f2> :MyoRunChained test s:vimtest<cr>

let g:ctrlp_custom_ignore['dir'] .= '|<%(bin|gen)>'
