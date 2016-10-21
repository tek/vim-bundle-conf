if !isdirectory(g:LatexBox_build_dir)
  execute 'silent! !mkdir -p '.g:LatexBox_build_dir
endif

MaqueAddCommand 'X', { 'name': 'exit', 'shell': 'auto' }
nnoremap <silent> <f11> :MaqueRunCommand exit<cr>

let g:maque_main.errorfile = 'build/main.log'

let g:maque_auto.capture = 0
let g:maque_auto.compiler = 'tektex'
