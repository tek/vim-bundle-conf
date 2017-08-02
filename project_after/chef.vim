let g:maque_chef_cookbook = substitute(g:proteome_main_name, '^chef_', '', '')

function! ChefUploadForce() abort "{{{
  return 'berks upload --force ' . g:maque_chef_cookbook
endfunction "}}}

MyoShellCommand upload { 'line': 'berks upload' }
MyoShellCommand upload_force { 'eval': True, 'line': 'vim:ChefUploadForce' }

nnoremap <silent> <f6> :MyoRun upload<cr>
nnoremap <silent> <s-f6> :MyoRun upload_force<cr>
