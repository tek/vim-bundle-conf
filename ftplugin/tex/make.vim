let b:maque_args_latexmk =
      \ '-silent -file-line-error ' .
      \ '-pdf -pdflatex=lualatex -jobname=build/' . expand('%:t:r')
