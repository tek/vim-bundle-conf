let g:myo_latexmk_line =
      \ 'latexmk -pdf -silent -file-line-error -pdflatex=lualatex' .
      \ ' -jobname=build/' . g:project_name . ' ' . g:latex_extra_args .
      \ ' main.tex'

MyoShellCommand latexmk { 'line': 'var:myo_latexmk_line', 'eval': True }
