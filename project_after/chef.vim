" MaqueAddCommand 'vagrant provision', { 'name': 'provision', 'remember': 1 }
" MaqueAddService 'vagrant ssh', { 'name': 'ssh', 'create_minimized': 0 }
MyoShellCommand 'upload', { 'name': 'berks upload' }

nnoremap <silent> <f6> :MyoRun upload<cr>
