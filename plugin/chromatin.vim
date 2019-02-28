let g:chromatin_rplugins = get(g:, 'chromatin_rplugins', [])

let s:myo_pp = [
      \ '/home/tek/code/tek/python_nvim/myo',
      \ '/home/tek/code/tek/python_nvim/ribosome',
      \ '/home/tek/code/tek/python/chiasma',
      \ '/home/tek/code/tek/python/amino',
      \ '/home/tek/.virtualenvs/myo/lib/python3.7/site-packages'
      \ ]

if get(g:, 'crm_haskell', 0) || get(g:, 'nvim_hs_vim', 0)
  let g:chromatin_rplugins += [{ 'spec': 'pip:myo~=1.0.3.a', 'name': 'myo', 'dev': v:false }]
else
  if get(g:, 'myo_dev', 0)
    let g:chromatin_rplugins += [
          \ { 'name': 'myo', 'spec': 'dir:/home/tek/code/tek/python_nvim/myo', 'pythonpath': s:myo_pp, 'debug': v:true }
          \ ]
  else
    let g:chromatin_rplugins += [{ 'spec': 'myo~=1.0.0.a', 'name': 'myo' }]
  endif

  if g:proteome_alpha
    let g:chromatin_rplugins += [{ 'spec': 'hackage:proteome', 'name': 'proteome', 'debug': v:true }]
  else
    let g:chromatin_rplugins += [{ 'spec': 'proteome~=11.4.0', 'name': 'proteome', 'interpreter': 'python3.6' }]
  endif
endif
