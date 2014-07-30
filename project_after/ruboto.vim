function! s:setup_maque() abort "{{{
  let main_pane = maque#tmux#pane('main')
  let main_pane.capture = 0
endfunction "}}}

augroup maque_ruboto_project
  autocmd!
  autocmd User MaqueTmuxPanesCreated call <sid>setup_maque()
  autocmd User MaqueTmuxMake MaqueTmuxResetCapture log
augroup END

nnoremap <silent> <f5> :MaqueRunCommand install<cr>
nnoremap <silent> <f6> :MaqueRunCommand update<cr>
nnoremap <silent> <f7> :MaqueToggleCommand log<cr>

set path+=src

set errorformat=
    \%.%#at\ %m(%.%#files/scripts/%f:%l),
    \%.%#at\ %m(%.%#apk!/%f:%l),
    \%-G%.%#
let g:errorformat = &errorformat

augroup tek_ruboto
  autocmd!
  autocmd QuickFixCmdPre cgetfile cd src
  autocmd QuickFixCmdPost cgetfile cd ..
augroup END

let g:maque_tmux_error_pane = 'log'

MaqueAddService 'adb logcat -s ' . g:project_name .
      \ ' RUBOTO:D AndroidRuntime:E', { 'name': 'log', 'size': 30,
      \ 'manual_termination': 1, 'capture': 1, 'minimized_size': 5,
      \ 'start': 1 }
MaqueAddService 'ruboto emulator', { 'name': 'emulator' }
MaqueAddCommand 'rake install start', { 'name': 'install', 'copy_to_main': 1 }
MaqueAddCommand 'rake uninstall', { 'name': 'uninstall' }
MaqueAddCommand 'rake update_scripts:restart', { 'name': 'update',
      \ 'copy_to_main': 1 }
MaqueAddCommand 'rake release', { 'name': 'release' }
