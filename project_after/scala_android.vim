let s:override = exists("g:override_project_android")

let g:output_name = get(g:, 'logcat_output_name', g:project_name)

if !s:override
  MaqueAddService 'while true; do adb logcat -s ' . g:output_name . ':I' .
        \ ' AndroidRuntime:E; done', { 'name': 'log', 'size': 30,
        \ 'manual_termination': 1, 'capture': 1, 'minimized_size': 5,
        \ 'start': 1, 'position': 0.5 }

  call AddScalaProjects('droid')
endif

call AddScalaProjects('macroid')

MaqueAddCommand 'rm **/proguard-cache*.jar', {
        \ 'name': 'delete proguard cache',
        \ }

let g:ctrlp_custom_ignore['dir'] .= '|<free/unit/libRes>'
