function! Register_python_completer() "{{{
  python <<EOF
from ycm_tek import register as ycm_tek_reg
ycm_tek_reg(ycm_state)
EOF
endfunction "}}}

if has('python')

  augroup youcompletemeStart
    autocmd VimEnter * call Register_python_completer()
  augroup END

endif
