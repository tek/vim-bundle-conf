nnoremap <silent> <leader><F5> :LatexView<cr>

set makeprg=latexmk
let g:LatexBox_build_dir = 'build'
let g:LatexBox_latexmk_options = '-pdflatex=lualatex -jobname='.g:LatexBox_build_dir . '/' . g:project_name
