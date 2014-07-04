function! s:setup_maque() abort "{{{
  call maque#tmux#add_pane('emulator', { '_splitter': 'tmux neww -d' })
  call maque#tmux#add_pane('log', {
        \ 'eval_splitter': 0,
        \ '_splitter': 'tmux split-window -v -d -p 40 "zsh -f"', 
        \ 'capture': 1,
        \ 'autoclose': 1,
        \ 'vertical': 0,
        \ 'minimized_size': 5,
        \ 'create_minimized': 0,
        \ 'restore_on_make': 0,
        \ 'manual_termination': 1,
        \ }
        \ )
  call maque#add_command('emulator', 'ruboto emulator',
        \ { 'pane': 'emulator', })
  call maque#add_command('install', 'rake install start',
        \ { 'pane': 'main', 'copy_to_main': 1, })
  call maque#add_command('uninstall', 'rake uninstall', { 'pane': 'main', })
  call maque#add_command('update', 'rake update_scripts:restart',
        \ { 'pane': 'main', 'copy_to_main': 1 })
  call maque#add_command('release', 'rake release', { 'pane': 'main', })
  call maque#add_command('log', 'adb logcat -s ' . g:project_name .
        \ ' RUBOTO:D AndroidRuntime:E', { 'pane': 'log', })
  let main_pane = maque#tmux#pane('main')
  let main_pane.capture = 0
endfunction "}}}

augroup maque_ruboto_project
  autocmd!
  autocmd User MaqueTmuxPanesCreated call <sid>setup_maque()
augroup END

command! PreMaque SaveAll|MaqueTmuxResetCapture log

nnoremap <silent> <f5> :PreMaque<cr>:MaqueRunCommand install<cr>
nnoremap <silent> <f6> :PreMaque<cr>:MaqueRunCommand update<cr>
nnoremap <silent> <f11> :MaqueToggleCommand log<cr>

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
