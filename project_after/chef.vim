let g:maque_chef_cookbook = substitute(g:proteome_main_name, '^chef_', '', '')

function! ChefUploadForce() abort "{{{
  return 'berks upload --force ' . g:maque_chef_cookbook
endfunction "}}}

MyoShellCommand converge { 'line': 'kitchen converge' }
MyoShellCommand verify { 'line': 'kitchen verify' }
MyoShellCommand login { 'line': 'kitchen login', 'focus': True }
MyoShellCommand upload { 'line': 'berks upload' }
MyoShellCommand upload_force { 'eval': True, 'line': 'vim:ChefUploadForce' }

nnoremap <silent> <f5> :MyoRun verify<cr>
nnoremap <silent> <f6> :MyoRun converge<cr>
nnoremap <silent> <f8> :MyoRun login<cr>
nnoremap <silent> <f7> :MyoRun upload<cr>
nnoremap <silent> <s-f7> :MyoRun upload_force<cr>
