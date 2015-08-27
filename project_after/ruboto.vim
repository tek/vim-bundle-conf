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
nnoremap <silent> <f8> :MaqueRunCommand test<cr>
nnoremap <silent> <s-f4> :MaqueRunCommand update bundle<cr>

set path+=src

set errorformat=
    \%.%#at\ %m(%.%#files/scripts/%f:%l),
    \%.%#at\ %m(%.%#apk!/%f:%l),
    \%-G%.%#
let g:errorformat = &errorformat
let g:maque_qf_path_ignore += ['src/ruboto']

augroup tek_ruboto
  autocmd!
  autocmd QuickFixCmdPre cgetfile cd src
  autocmd QuickFixCmdPost cgetfile cd ..
augroup END

let g:maque_tmux_error_pane = 'log'

MaqueAddService 'while true; do adb logcat -s ' . g:project_name .
      \ ' RUBOTO:D AndroidRuntime:E; done', { 'name': 'log', 'size': 30,
      \ 'manual_termination': 1, 'capture': 1, 'minimized_size': 5,
      \ 'start': 1 }
MaqueAddService 'ruboto emulator', { 'name': 'emulator' }
MaqueAddCommand 'rake install start', { 'name': 'install', 'remember': 1 }
MaqueAddCommand 'rake uninstall', { 'name': 'uninstall' }
MaqueAddCommand 'rake boing', { 'name': 'update', 'remember': 1 }
MaqueAddCommand 'rake release', { 'name': 'release' }
MaqueAddCommand 'rake test', { 'name': 'test' }
MaqueAddCommand 'rm libs/bundle.jar Gemfile.apk.lock; rake bundle',
      \ { 'name': 'update bundle' }
