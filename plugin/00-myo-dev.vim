if !exists('$CRM_DEV')
  finish
endif

let g:myo_components = [
      \ 'ui',
      \ 'tmux',
      \ 'command',
      \ ]

nnoremap <silent> <f9> :MyoTogglePane make<cr>
nnoremap <silent> <f6> :MyoRunCommand compile<cr>

function! MC() abort "{{{
  MyoCreatePane { "layout": "make", "name": "sbt" }
  MyoAddSystemCommand { "ident": "sbt", "line": "sbt", "target": "sbt" }
  MyoAddShellCommand { "ident": "compile", "line": "compile", "target": "sbt" }
endfunction "}}}
