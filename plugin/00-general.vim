" variables {{{

" python moduledir
let g:python_modules_bundle_conf = fnamemodify(expand('<sfile>:h').'/../python', ':p')

function! CreateBgLayout() abort "{{{
  let layout = maque#tmux#add_window('bg')
endfunction "}}}

if exists('$kaon')
  autocmd User MaqueTmuxPanesCreated call CreateBgLayout()
endif

" }}}
