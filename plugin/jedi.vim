let g:jedi#goto_command = 'gd'
let g:jedi#auto_initialization = 0
let g:jedi#popup_on_dot = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#show_function_definition = 1
autocmd InsertLeave *.py python jedi_vim.clear_func_def()
autocmd CursorMovedI *.py call jedi#show_func_def()
