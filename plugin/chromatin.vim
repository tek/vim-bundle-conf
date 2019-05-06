let g:chromatin_rplugins = get(g:, 'chromatin_rplugins', [])

let s:myo_pp = [
      \ '/home/tek/code/tek/python_nvim/myo',
      \ '/home/tek/code/tek/python_nvim/ribosome',
      \ '/home/tek/code/tek/python/chiasma',
      \ '/home/tek/code/tek/python/amino',
      \ '/home/tek/.virtualenvs/myo/lib/python3.7/site-packages'
      \ ]

if !(get(g:, 'myo_hs', 0) || get(g:, 'myo_hs_dev', 0))
  let g:chromatin_rplugins += [{ 'spec': 'pip:myo~=1.0.3.a', 'name': 'myo', 'dev': v:false }]
endif
