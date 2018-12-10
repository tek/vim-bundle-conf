let g:chromatin_rplugins = []

let s:pp = [
      \ '/home/tek/code/tek/python_nvim/myo',
      \ '/home/tek/code/tek/python_nvim/ribosome',
      \ '/home/tek/code/tek/python/chiasma',
      \ '/home/tek/code/tek/python/amino',
      \ '/home/tek/.virtualenvs/myo/lib/python3.7/site-packages'
      \ ]
" let g:chromatin_rplugins += [
"       \ { 'name': 'myo', 'spec': 'dir:/home/tek/code/tek/python_nvim/myo', 'pythonpath': s:pp, 'debug': v:true }
"       \ ]
let g:chromatin_rplugins += [{ 'spec': 'myo~=1.0.0.a', 'name': 'myo' }]
if g:proteome_alpha
  let g:chromatin_rplugins += [{ 'spec': 'hackage:proteome', 'name': 'proteome', 'debug': v:true }]
else
  let g:chromatin_rplugins += [{ 'spec': 'proteome~=11.4.0', 'name': 'proteome', 'interpreter': 'python3.6' }]
endif
