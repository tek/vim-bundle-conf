let g:chef_cookbook = substitute(g:proteome_main_name, '^chef_', '', '')

function! ChefUploadForce() abort "{{{
  return 'berks upload --force ' . g:chef_cookbook
endfunction "}}}

MyoAddShellCommand { "ident": "converge", "line": "kitchen converge" }
MyoAddShellCommand { "ident": "verify", "line": "kitchen verify" }
MyoAddShellCommand { "ident": "login", "line": "kitchen login", "focus": True }
MyoAddShellCommand { "ident": "upload", "line": "berks upload" }
" MyoAddShellCommand { "ident": "upload_force", "eval": True, "line": "vim:ChefUploadForce" }

nnoremap <silent> <f5> :MyoRun verify<cr>
nnoremap <silent> <f6> :MyoRun converge<cr>
nnoremap <silent> <f8> :MyoRun login<cr>
nnoremap <silent> <f7> :MyoRun upload<cr>
nnoremap <silent> <s-f7> :MyoRun upload_force<cr>
