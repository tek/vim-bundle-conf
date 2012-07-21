call OnSyntaxChange#Install('DocString', 'pythonDocString', 1, 'n')
augroup tek_py_syntaxchange
  autocmd User SyntaxDocStringEnterN set tw=72
  autocmd User SyntaxDocStringLeaveN set tw=79
augroup end
