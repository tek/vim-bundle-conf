function! Maque_chef_run() abort "{{{
  return 'knife ssh -x root "name:' . g:maque_chef_node_name . '" chef-client'
endfunction "}}}

MaqueAddCommand 'berks upload --force tryp', { 'name': 'upload_tryp' }
MaqueAddCommand 'Maque_chef_run()',
      \ { 'name': 'pulsar_run', 'cmd_type': 'eval' }

nnoremap <silent> <f5> :MaqueRunCommand upload_tryp<cr>:MaqueQueueCommand pulsar_run<cr>

let g:maque_chef_node_name = 'pulsar'
let g:maque_chef_cookbook = g:project_name
