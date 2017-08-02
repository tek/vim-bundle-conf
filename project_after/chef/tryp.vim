function! Myo_chef_run() abort "{{{
  return 'knife ssh -x root "name:' . g:maque_chef_node_name . '" chef-client'
endfunction "}}}

MyoShellCommand upload_tryp { 'line': 'berks upload --force tryp' }
MyoShellCommand run_tryp { 'line': 'vim:Myo_chef_run', 'eval': True }

nnoremap <silent> <f5> :MyoRunChained upload_tryp run_tryp<cr>

let g:maque_chef_node_name = 'pulsar'

let g:myo_chainer = 'py:myo_bundle.chain_shell'
