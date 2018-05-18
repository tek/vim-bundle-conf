let g:chromatin_rplugins = []

let g:crm_dev = exists('$CRM_DEV')

if g:crm_dev
  " let g:chromatin_debug_pythonpath = v:true
  " let g:chromatin_rplugins += [{ 'name': 'proteome', 'spec': '/home/tek/code/tek/python_nvim/proteome' }]
  let s:pp = [
        \ '/home/tek/code/tek/python_nvim/myo',
        \ '/home/tek/code/tek/python_nvim/ribosome',
        \ '/home/tek/code/tek/python/chiasma',
        \ '/home/tek/code/tek/python/amino',
        \ '/home/tek/.virtualenvs/myo/lib/python3.6/site-packages'
        \ ]
  let g:chromatin_rplugins += [
        \ { 'name': 'myo', 'spec': 'dir:/home/tek/code/tek/python_nvim/myo/myo', 'pythonpath': s:pp, 'debug': v:true }
        \ ]
  let g:chromatin_rplugins += [{ 'spec': 'proteome~=11.4.0', 'name': 'proteome' }]
  " let g:chromatin_rplugins += [{ 'name': 'tubbs', 'spec': '/home/tek/code/tek/python_nvim/tubbs' }]
else
  let g:chromatin_rplugins += [{ 'spec': 'proteome~=11.4.0', 'name': 'proteome' }]
  let g:chromatin_rplugins += [{ 'spec': 'myo~=0.36.0', 'name': 'myo' }]
  " \ ,
  " let g:chromatin_rplugins += [{ 'spec': 'tubbs' }]
endif
