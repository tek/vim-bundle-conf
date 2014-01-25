call maque#tmux#add_pane('emulator', { '_splitter': 'tmux neww -d' })
call maque#tmux#add_pane('log', {
      \ 'eval_splitter': 0,
      \ '_splitter': 'tmux split-window -v -d -p 40 "zsh -f"', 
      \ 'capture': 1,
      \ 'autoclose': 1,
      \ 'vertical': 0,
      \ 'minimized_size': 5,
      \ 'create_minimized': 1,
      \ 'restore_on_make': 0,
      \ 'manual_termination': 1,
      \ }
      \ )

call maque#add_command('emulator', 'ruboto emulator', { 'pane': 'emulator', })
call maque#add_command('install', 'rake install', { 'pane': 'main', })
call maque#add_command('uninstall', 'rake uninstall', { 'pane': 'main', })
call maque#add_command('restart', 'rake update_scripts:restart', { 'pane': 'main', })
call maque#add_command('test', 'rake test', { 'pane': 'main', })
call maque#add_command('log', 'adb logcat -s '.g:project_name.' RUBOTO:D \*:E', { 'pane': 'log', })
let main_pane = maque#tmux#pane('main')
let main_pane.capture = 0

command! PreMaque SaveAll<bar>MaqueTmuxResetCapture log

nnoremap <silent> <leader><f5> :SaveAll<cr>:MaqueRunCommand install<cr>
nnoremap <silent> <leader><f6> :SaveAll<cr>:MaqueRunCommand uninstall<cr>
nnoremap <silent> <leader><f7> :SaveAll<cr>:MaqueRunCommand restart<cr>
nnoremap <silent> <leader><f8> :SaveAll<cr>:MaqueRunCommand test<cr>
nnoremap <silent> <f11> :MaqueToggleTmux log<cr>

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
