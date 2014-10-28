MaqueAddService 'while true; do adb logcat -s ' . g:project_name .
      \ ' AndroidRuntime:E; done', { 'name': 'log', 'size': 30,
      \ 'manual_termination': 1, 'capture': 1, 'minimized_size': 5,
      \ 'start': 1 }
