let s:override = exists("g:override_project_android")

let g:output_name = get(g:, 'logcat_output_name', g:project_name)

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

let g:ctrlp_custom_ignore['dir'] .= '|<%(bin|gen)>'
