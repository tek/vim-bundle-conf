nnoremap <silent> <leader><F3> :LatexView<cr>

function! s:set_latex_handler() abort "{{{
  let cmd = maque#command('main')
  let cmd.handler = 'latex_box'
endfunction "}}}

augroup maque_tex_project
  autocmd!
  autocmd User MaqueCommandsCreated call <sid>set_latex_handler()
augroup END

let g:LatexBox_build_dir = 'build'
let g:LatexBox_latexmk_options = '-pdflatex=lualatex -jobname='.g:LatexBox_build_dir . '/' . g:project_name
