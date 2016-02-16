fun! s:template_keywords() "{{{
  for var in ['year', 'author']
    let val = eval('g:template_'.var)
    exe '%s/<'.var.'>/'.val.'/e'
  endfor
  python3 << END
try:
  import vim
  from os import path
  from tek.tools import camelcaseify
  import re
except:
    pass
try:
    match = re.search(r'/([^/]+)_(test|spec).py$', vim.current.buffer.name)
    if match:
      name = camelcaseify(match.group(1))
      vim.command('let l:pytestname="{}_"'.format(name))
except Exception as e:
    print('Error while creating python test class name: {}'.format(e))
try:
    match = re.search('([^/]+)_controller.coffee$', vim.current.buffer.name)
    if match:
      ctrl = match.group(1)
      vim.command('let l:coffee_ctrl = "{}"'.format(camelcaseify(ctrl)))
except Exception as e:
    print('Error while creating coffee controller name: {}'.format(e))
END
  if exists('l:pytestname')
    exe '%s#<pythontestname>#'.l:pytestname.'#e'
  endif
  if exists('l:coffee_ctrl')
    exe '%s#<coffee_ctrl_name>#'.l:coffee_ctrl.'#e'
  endif
	if search('<+CURSOR+>')
    execute 's#<+CURSOR+>##'
	endif
  normal! zv
  call histdel("search", -1)
endfunction "}}}

" skeletons
let g:template_year = strftime('%Y')
let g:template_author = 'Torsten Schmits'

augroup tek_template_subst
  " after the template for a new file has been loaded, replace keywords like
  " date and name
  autocmd!
  autocmd User plugin-template-loaded call s:template_keywords()
augroup end
