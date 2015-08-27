MaqueAddCommand 'berks upload --force tryp', { 'name': 'upload_tryp' }
MaqueAddCommand 'knife ssh -x root "name:pulsar" chef-client', { 'name': 'pulsar_run' }

nnoremap <silent> <f5> :MaqueRunCommand upload_tryp<cr>:MaqueQueueCommand pulsar_run<cr>

let g:maque_chef_node_name = 'pulsar'
let g:maque_chef_cookbook = g:project_name
