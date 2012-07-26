try
  call OnSyntaxChange#Install('DocString', 'pythonDocString', 1, 'n')
catch /^Vim\%((\a\+)\)\=:E117/
  echo 'OnSyntaxChange not installed.'
endtry
