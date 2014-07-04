try
  call OnSyntaxChange#Install('DocString', 'pythonDocString', 1, 'a')
catch /^Vim\%((\a\+)\)\=:E117/
  echo 'OnSyntaxChange not installed.'
endtry
