function! Register_python_completer() "{{{
python <<EOF
try:
  from ycm_tek import register as ycm_tek_reg
except ImportError as e:
  print e
else:
  ycm_tek_reg(ycm_state)
EOF
endfunction "}}}

if has('python') && exists('g:loaded_youcompleteme')

  augroup youcompletemeStart
    autocmd VimEnter * call Register_python_completer()
  augroup END

endif
