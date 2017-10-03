let g:chromatin_rplugins = []

if exists('$CRM_DEV')
  let g:chromatin_rplugins += [{ 'name': 'proteome', 'spec': '/home/tek/code/tek/python_nvim/proteome' }]
  let g:chromatin_rplugins += [{ 'name': 'myo', 'spec': '/home/tek/code/tek/python_nvim/myo' }]
  " let g:chromatin_rplugins += [{ 'name': 'tubbs', 'spec': '/home/tek/code/tek/python_nvim/tubbs' }]
else
  let g:chromatin_rplugins += [{ 'spec': 'proteome~=11.0.0', 'name': 'proteome' }]
  let g:chromatin_rplugins += [{ 'spec': 'myo~=0.34.0', 'name': 'myo' }]
  " \ ,
  " let g:chromatin_rplugins += [{ 'spec': 'tubbs' }]
endif
