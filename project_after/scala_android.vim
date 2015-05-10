let s:override = exists("g:override_project_android")

if !s:override
  MaqueAddService 'while true; do adb logcat -s ' . g:project_name . ':I' .
        \ ' AndroidRuntime:E; done', { 'name': 'log', 'size': 30,
        \ 'manual_termination': 1, 'capture': 1, 'minimized_size': 5,
        \ 'start': 1 }

  let g:root_dirs += ['../../scala/droid/src', 'app/src']
endif

let g:ctrlp_custom_ignore['dir'] .= '|<free/unit/util>'