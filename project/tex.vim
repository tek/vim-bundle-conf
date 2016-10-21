nnoremap <silent> <leader><F5> :LatexView<cr>

set makeprg=latexmk

let s:central = $HOME . '/res/tex'

if isdirectory(s:central)
  let s:build_dir = s:central . '/' . g:project_name
  if !isdirectory('build')
    execute 'silent! ! ln -s ' . s:build_dir . ' build'
  endif
endif

let g:LatexBox_build_dir = 'build'
let s:args = ''
let g:LatexBox_latexmk_options =
      \ '-silent -file-line-error' .
      \ '-pdflatex=lualatex -jobname=build/' . g:project_name

let g:neomake_tex_enabled_makers = ['chktex']
