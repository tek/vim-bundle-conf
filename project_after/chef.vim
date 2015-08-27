MaqueAddCommand 'vagrant provision', { 'name': 'provision', 'remember': 1 }
MaqueAddService 'vagrant ssh', { 'name': 'ssh', 'create_minimized': 0 }
MaqueAddCommand 'berks upload', { 'name': 'upload' }

nnoremap <silent> <f6> :MaqueRunCommand upload<cr>
